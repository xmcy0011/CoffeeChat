package data

import (
	"CoffeeChat/log"
	"context"
	"user/internal/data/ent"
	"user/internal/data/ent/device"
)

type DeviceRepo interface {
	Save(context.Context, *ent.Device) (*ent.Device, error)
	Update(context.Context, *ent.Device) error
	FindByID(context.Context, int32) (*ent.Device, error)
	FindByDeviceId(ctx context.Context, deviceId string) (*ent.Device, error)
	ListAll(context.Context) ([]*ent.Device, error)
}

type deviceRepo struct {
	data *Data
	log  *log.Logger
}

func NewDeviceRepo(data *Data, logger *log.Logger) DeviceRepo {
	return &deviceRepo{
		data: data,
		log:  logger,
	}
}

func (d *deviceRepo) Save(ctx context.Context, dev *ent.Device) (*ent.Device, error) {
	return d.data.Device.Create().
		SetDeviceID(dev.DeviceID).
		SetAppVersion(dev.AppVersion).
		SetOsVersion(dev.OsVersion).
		Save(ctx)
}
func (d *deviceRepo) Update(ctx context.Context, dev *ent.Device) error {
	return d.data.Device.UpdateOne(dev).Exec(ctx)
}
func (d *deviceRepo) FindByID(ctx context.Context, id int32) (*ent.Device, error) {
	return d.data.Device.Query().Where(device.ID(id)).Only(ctx)
}
func (d *deviceRepo) FindByDeviceId(ctx context.Context, deviceId string) (*ent.Device, error) {
	return d.data.Device.Query().Where(device.DeviceID(deviceId)).Only(ctx)
}
func (d *deviceRepo) ListAll(ctx context.Context) ([]*ent.Device, error) {
	return d.data.Device.Query().All(ctx)
}
