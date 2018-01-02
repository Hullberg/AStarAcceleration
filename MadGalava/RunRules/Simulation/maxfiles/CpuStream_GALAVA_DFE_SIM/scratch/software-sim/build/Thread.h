#ifndef MANAGER_INFRASTRUCTURE_THREAD_H
#define MANAGER_INFRASTRUCTURE_THREAD_H
// This is a wrapper class for std::thread that can do interruption.

#include <atomic>
#include <functional>
#include <map>
#include <mutex>
#include <thread>
#include <utility>

#include <pthread.h>

namespace maxcompilersim {

class CondVar;

class Thread {
  friend class CondVar;
  std::atomic_bool stop;
  std::thread thread;
  static std::map<pthread_t, const Thread *> threadMap;
  static std::mutex threadMapLock;

  public:
    Thread() = default;

    template<class Function, typename... Args> Thread(Function &&func, Args&&... args) : stop(false) {
	  auto f = std::bind(std::forward<Function>(func), std::forward<Args>(args)...);
	  auto lambda = [this, f] {
		{
		  std::unique_lock<std::mutex> lock(threadMapLock);
		  threadMap[pthread_self()] = this;
		}
		f();
		{
		  std::unique_lock<std::mutex> lock(threadMapLock);
		  threadMap.erase(pthread_self());
		}
	  };
	  thread = std::thread(lambda);
	}
	void join() {
	  thread.join();
	}
	void interrupt() {
	  stop = true;
	}
	bool shouldStop() const {
	  return stop.load();
	}
};

}

#endif
