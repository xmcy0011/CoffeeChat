package utils

import (
	"CoffeeChat/log"
	"context"
	"database/sql/driver"
	"github.com/pkg/errors"
)

func EntWithTx(tx driver.Tx, log *log.Logger, ctx context.Context, cb func(ctx context.Context) error) error {
	var err error = nil

	defer func() {
		if r := recover(); r != nil {
			if err = tx.Rollback(); err != nil {
				log.Warn(err.Error())
			} else {
				log.Warn("panic and rollback transaction success!")
			}
		}
	}()

	if err = cb(ctx); err != nil {
		if err = tx.Rollback(); err != nil {
			err = errors.Wrapf(err, "rollback transaction error:%v", err)
		}
		return err
	}
	if err = tx.Commit(); err != nil {
		err = errors.Wrapf(err, "commiting trasaction error:%v", err)
	}
	return err
}
