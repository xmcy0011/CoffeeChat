package jwt

import (
	"github.com/stretchr/testify/assert"
	"testing"
)

var (
	accessSecret  = "access"
	refreshSecret = "refresh"
)

func TestTokenGenerate_CreateToken(t *testing.T) {
	generate := NewTokenGenerate(accessSecret, refreshSecret)

	c := ClientInfo{
		UserId:     2022,
		DeviceId:   "f23123-233",
		ClientType: "ios",
		Domain:     "im",
	}

	token, err := generate.CreateToken(c)
	assert.NoError(t, err)
	t.Log("generate token success\naccessToken:", token.AccessToken, "\nrefreshToken:", token.RefreshToken)
}

func TestTokenGenerate_ParseToken(t *testing.T) {
	generate := NewTokenGenerate(accessSecret, refreshSecret)

	accessToken := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2Nlc3NfdXVpZCI6ImQ0NDkyMWFiLWJiYzUtNDMxZS04YTZmLTRiZDE3YTU3YWJlMiIsImF0X2V4cGlyZXMiOjE2NjEyMjU5MDksImNsaWVudF90eXBlIjoiaW9zIiwiZGV2aWNlX2lkIjoiZjIzMTIzLTIzMyIsImRvbWFpbiI6ImltIiwidXNlcl9pZCI6MjAyMn0.xzqMRnvfV-hjLnRYWnjo200C3tm2Ve8QEP7dEBzrPPY"
	err := generate.TokenIsValid(accessToken, false)
	assert.NoError(t, err)

	refreshToken := "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJjbGllbnRfdHlwZSI6ImlvcyIsImRldmljZV9pZCI6ImYyMzEyMy0yMzMiLCJkb21haW4iOiJpbSIsInJlZnJlc2hfdXVpZCI6IjA3YzM0OTliLTAwMzItNGIwNC1iY2FjLWEzZmUxYjQ5ZDNlZiIsInJ0X2V4cGlyZXMiOjE2NjM4MTcwMDksInVzZXJfaWQiOjIwMjJ9.-jAY9rKV0DHhoFYaaoF8tfHyFxzs3mlCk7L6lU__QIQ"
	err = generate.TokenIsValid(refreshToken, true)
	assert.NoError(t, err)

	c, _, err := generate.ParseToken(accessToken, false)
	assert.NoError(t, err)
	t.Log("access clintInfo:", c)

	c, _, err = generate.ParseToken(refreshToken, true)
	assert.NoError(t, err)
	t.Log("refresh clintInfo:", c)
}
