package biz

import (
	"CoffeeChat/log"
	"context"
	"user/internal/data/ent"
)

type Device struct {
	ID         int32
	DeviceID   string
	AppVersion int32
	OsVersion  string
}

type DeviceRepo interface {
	Create(context.Context, *Device) (*Device, error)
	UpdateByDevice(ctx context.Context, deviceId string, newDevice *Device) error
	FindByID(context.Context, int32) (*Device, error)
	FindByDeviceId(ctx context.Context, deviceId string) (*Device, error)
	ListAll(context.Context) ([]*Device, error)
}

type DeviceUseCase struct {
	repo DeviceRepo
	log  *log.Logger
}

func NewDeviceUseCase(deviceRepo DeviceRepo, logger *log.Logger) *DeviceUseCase {
	return &DeviceUseCase{repo: deviceRepo, log: logger}
}

func (d *DeviceUseCase) Register(ctx context.Context, device *Device) (*Device, error) {
	po, err := d.repo.FindByDeviceId(ctx, device.DeviceID)
	if err != nil {
		if ent.IsNotFound(err) {
			return d.repo.Create(ctx, device)
		}
		return nil, err
	}

	err = d.repo.UpdateByDevice(ctx, device.DeviceID, device)
	if err != nil {
		return nil, err
	}
	device.ID = po.ID
	return device, nil
}
