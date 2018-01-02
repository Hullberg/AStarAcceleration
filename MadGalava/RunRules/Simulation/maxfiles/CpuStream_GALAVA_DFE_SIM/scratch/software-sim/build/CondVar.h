#ifndef MANAGER_INFRASTRUCTURE_COND_VAR_H
#define MANAGER_INFRASTRUCTURE_COND_VAR_H
#include <condition_variable>
#include <memory>
#include <mutex>

#include "Thread.h"

namespace maxcompilersim {

// This is a wrapper for std::condition_variable that supports our std::thread
// interruption.
class CondVar {
  std::condition_variable cond_var;

  bool shouldStop() const {
	std::unique_lock<std::mutex> l(Thread::threadMapLock);
	auto it = Thread::threadMap.find(pthread_self());
	return (it != Thread::threadMap.end() && it->second->shouldStop());
  }

public:
  void wait(std::unique_lock<std::mutex>& lock) {
	while (!shouldStop()) {
	  if (cond_var.wait_for(lock, std::chrono::milliseconds(100)) == std::cv_status::no_timeout)
		return;
	}
	pthread_exit(NULL);
  }

  template<class Rep, class Period> std::cv_status wait_for(std::unique_lock<std::mutex> &lock, const std::chrono::duration<Rep, Period> &rel_time) {
	{
	  std::unique_lock<std::mutex> l(Thread::threadMapLock);
	  auto it = Thread::threadMap.find(pthread_self());

	  if (it != Thread::threadMap.end() && it->second->shouldStop())
		return std::cv_status::no_timeout;
	}

	std::cv_status ret = cond_var.wait_for(lock, rel_time);
	if (ret == std::cv_status::timeout && shouldStop())
		pthread_exit(NULL);
	return ret;
  }

  void notify_one() {
	cond_var.notify_one();
  }

  void notify_all() {
	cond_var.notify_all();
  }
};

}

#endif
