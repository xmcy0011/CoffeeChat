package data

import (
	"CoffeeChat/log"
	"context"
	"user/internal/biz"
	"user/internal/data/ent"
	"user/internal/data/ent/device"
)

type deviceRepo struct {
	data *Data
	log  *log.Logger
}

var _ biz.DeviceRepo = (*deviceRepo)(nil)

func NewDeviceRepo(data *Data, logger *log.Logger) biz.DeviceRepo {
	return &deviceRepo{
		data: data,
		log:  logger,
	}
}

func (d *deviceRepo) ent2Model(from *ent.Device) *biz.Device {
	return &biz.Device{
		ID:         from.ID,
		DeviceID:   from.DeviceID,
		AppVersion: from.AppVersion,
		OsVersion:  from.OsVersion,
	}
}
func (d *deviceRepo) Create(ctx context.Context, dev *biz.Device) (*biz.Device, error) {
	po, err := d.data.Device.Create().
		SetDeviceID(dev.DeviceID).
		SetAppVersion(dev.AppVersion).
		SetOsVersion(dev.OsVersion).
		Save(ctx)
	if err != nil {
		return nil, err
	}
	return d.ent2Model(po), nil
}
func (d *deviceRepo) UpdateByDevice(ctx context.Context, deviceId string, newDevice *biz.Device) error {
	_, err := d.data.Device.Update().Where(device.DeviceID(deviceId)).
		SetAppVersion(newDevice.AppVersion).
		SetOsVersion(newDevice.OsVersion).Save(ctx)
	return err
}
func (d *deviceRepo) FindByID(ctx context.Context, id int32) (*biz.Device, error) {
	po, err := d.data.Device.Query().Where(device.ID(id)).Only(ctx)
	if err != nil {
		return nil, err
	}
	return d.ent2Model(po), nil
}
func (d *deviceRepo) FindByDeviceId(ctx context.Context, deviceId string) (*biz.Device, error) {
	po, err := d.data.Device.Query().Where(device.DeviceID(deviceId)).Only(ctx)
	if err != nil {
		return nil, err
	}
	return d.ent2Model(po), nil
}
func (d *deviceRepo) ListAll(ctx context.Context) ([]*biz.Device, error) {
	poArr, err := d.data.Device.Query().All(ctx)
	if err != nil {
		return nil, err
	}
	result := make([]*biz.Device, 0, len(poArr))
	for _, v := range poArr {
		result = append(result, d.ent2Model(v))
	}
	return result, nil
}
