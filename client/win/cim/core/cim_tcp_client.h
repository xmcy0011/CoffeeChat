/** @file cim_tcp_client.h
  * @brief cim_tcp_client
  * @author yingchun.xu
  * @date 2020/8/20
  */

#ifndef _CIM_TCP_CLIENT_616739B1_29BC_4B6A_825B_F6250ACC9BC4_
#define _CIM_TCP_CLIENT_616739B1_29BC_4B6A_825B_F6250ACC9BC4_

#include "cim.h"
#include "cim/base/noncopyable.h"
#include <asio.hpp>

class CIMTcpClient: cim::noncopyable {
  public:
    CIMTcpClient();
    ~CIMTcpClient();

  private:

};

#endif//_CIM_TCP_CLIENT_616739B1_29BC_4B6A_825B_F6250ACC9BC4_