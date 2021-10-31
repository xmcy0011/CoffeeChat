package def

import "errors"

// default error
var DefaultError = errors.New("error")
var DBSlaveUnConnectError = errors.New("slave db disconnect")
