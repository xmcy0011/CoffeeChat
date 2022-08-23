package jwt

import (
	"errors"
	"fmt"
	"github.com/dgrijalva/jwt-go"
	"github.com/twinj/uuid"
	"time"
)

const (
	kAccessTokenExpire  = time.Minute * 15
	kRefreshTokenExpire = time.Hour * 24 * 30
)

type TokenDetails struct {
	AccessToken  string
	RefreshToken string
	AccessUuid   string
	RefreshUuid  string
	AtExpires    int64
	RtExpires    int64
}

type ClientInfo struct {
	UserId     int64
	DeviceId   string
	ClientType string
	Domain     string
}

type TokenGenerate struct {
	accessSecret  string
	refreshSecret string
}

// NewTokenGenerate create TokenGenerate
// example:
//
func NewTokenGenerate(accessSecret, refreshSecret string) *TokenGenerate {
	return &TokenGenerate{accessSecret: accessSecret, refreshSecret: refreshSecret}
}

func (t *TokenGenerate) CreateToken(info ClientInfo) (*TokenDetails, error) {
	td := &TokenDetails{}
	// access 过期快
	td.AtExpires = time.Now().Add(kAccessTokenExpire).Unix()
	td.AccessUuid = uuid.NewV4().String()

	// refresh token 过期时间长，用来获取新的access token
	td.RtExpires = time.Now().Add(kRefreshTokenExpire).Unix()
	td.RefreshUuid = uuid.NewV4().String()

	var err error

	//Creating Access Token
	atClaims := jwt.MapClaims{}
	t.setClientInfo(atClaims, info)
	atClaims["access_uuid"] = td.AccessUuid
	atClaims["at_expires"] = td.AtExpires
	at := jwt.NewWithClaims(jwt.SigningMethodHS256, atClaims)
	td.AccessToken, err = at.SignedString([]byte(t.accessSecret))
	if err != nil {
		return nil, err
	}

	//Creating Refresh Token
	rtClaims := jwt.MapClaims{}
	t.setClientInfo(rtClaims, info)
	rtClaims["refresh_uuid"] = td.RefreshUuid
	rtClaims["rt_expires"] = td.RtExpires
	rt := jwt.NewWithClaims(jwt.SigningMethodHS256, rtClaims)
	td.RefreshToken, err = rt.SignedString([]byte(t.refreshSecret))
	if err != nil {
		return nil, err
	}
	return td, nil
}

func (t *TokenGenerate) TokenIsValid(tokenStr string, isRefreshToken bool) error {
	_, err := t.GetClaimsFromJWTToken(tokenStr, isRefreshToken)
	if err != nil {
		return err
	}
	return nil
}

func (t *TokenGenerate) ParseToken(tokenStr string, isRefreshToken bool) (*ClientInfo, *TokenDetails, error) {
	claims, err := t.GetClaimsFromJWTToken(tokenStr, isRefreshToken)
	if err != nil {
		return nil, nil, err
	}
	clientInfo, err := t.getClientInfo(claims)
	if err != nil {
		return nil, nil, err
	}
	tokens := &TokenDetails{}
	if isRefreshToken {
		tokens.RefreshToken = tokenStr
		tokens.AccessUuid = claims["refresh_uuid"].(string)
		tokens.AtExpires = int64(claims["rt_expires"].(float64))
	} else {
		tokens.RefreshToken = tokenStr
		tokens.AccessUuid = claims["access_uuid"].(string)
		tokens.AtExpires = int64(claims["at_expires"].(float64))
	}
	return clientInfo, tokens, nil
}

func (t *TokenGenerate) setClientInfo(claims jwt.MapClaims, info ClientInfo) {
	claims["user_id"] = info.UserId
	claims["device_id"] = info.DeviceId
	claims["client_type"] = info.ClientType
	claims["domain"] = info.Domain
}

func (t *TokenGenerate) getClientInfo(claims jwt.MapClaims) (*ClientInfo, error) {
	info := &ClientInfo{}

	userId, ok := claims["user_id"].(float64)
	if ok {
		info.UserId = int64(userId)
	}
	if deviceId, ok := claims["device_id"].(string); ok {
		info.DeviceId = deviceId
	}
	if cType, ok := claims["client_type"].(string); ok {
		info.ClientType = cType
	}
	if domain, ok := claims["domain"].(string); ok {
		info.Domain = domain
	}
	return info, nil
}

func (t *TokenGenerate) GetClaimsFromJWTToken(tokenStr string, isRefreshToken bool) (jwt.MapClaims, error) {
	var (
		expires = float64(0)
		ok      = false
		claims  jwt.MapClaims
	)

	// check jwt secret
	token, err := jwt.Parse(tokenStr, func(token *jwt.Token) (interface{}, error) {
		//Make sure that the token method conform to "SigningMethodHMAC"
		if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
			return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
		}

		if isRefreshToken {
			return []byte(t.refreshSecret), nil
		}
		return []byte(t.accessSecret), nil
	})
	if err != nil {
		return nil, err
	}

	// check token valid
	if _, ok := token.Claims.(jwt.Claims); !ok {
		return nil, err
	}
	if !token.Valid {
		return nil, errors.New("invalid token")
	}
	// check token data
	if claims, ok := token.Claims.(jwt.MapClaims); ok {
		return claims, nil
	}

	// check token is expires
	if isRefreshToken {
		expires, ok = claims["rt_expires"].(float64)
	} else {
		expires, ok = claims["at_expires"].(float64)
	}
	if !ok {
		return nil, errors.New("token miss expires filed")
	}
	if time.Unix(int64(expires), 0).Before(time.Now()) {
		if isRefreshToken {
			return nil, errors.New("expired refresh token")
		}
		return nil, errors.New("expired access token")
	}
	return nil, errors.New("parse jwt.MapClaims error")
}
