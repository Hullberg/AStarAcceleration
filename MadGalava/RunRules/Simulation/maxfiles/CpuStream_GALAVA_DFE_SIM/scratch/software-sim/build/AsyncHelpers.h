#ifndef ASYNC_HELPERS_H_
#define ASYNC_HELPERS_H_

#include <memory>
#include <mutex>

#include "CondVar.h"

namespace maxcompilersim {

typedef std::mutex Mutex;
typedef std::shared_ptr<Mutex> MutexPtr;
typedef std::shared_ptr<CondVar> CondVarPtr;

} // namespace maxcompilersim

#endif // ASYNC_HELPERS_H_
