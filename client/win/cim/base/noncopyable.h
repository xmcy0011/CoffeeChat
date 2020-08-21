/** @file noncopyable.h
  * @brief noncopyable
  * @author yingchun.xu
  * @date 2020/8/20
  */

#ifndef _NONCOPYABLE_377FD72A_191C_4A10_805E_E43301C78BDC_
#define _NONCOPYABLE_377FD72A_191C_4A10_805E_E43301C78BDC_

namespace cim {
    class noncopyable {
      public:
        // 禁用拷贝构造
        noncopyable(const noncopyable&) = delete;
        // 禁用赋值
        void operator=(const noncopyable&) = delete;

      protected:
        noncopyable() = default;
        ~noncopyable() = default;
    };
}

#endif//_NONCOPYABLE_377FD72A_191C_4A10_805E_E43301C78BDC_