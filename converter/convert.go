package converter

import (
	"errors"
	"io"
	"strings"
)

const PathPrefix = "/convert/"

var (
	ErrDecode = errors.New("failed to decode")
	ErrEncode = errors.New("failed to encode")

	_ Converter = (*NopConverter)(nil)
)

type Converter interface {
	Convert(dst io.Writer, src io.Reader) error
}

// NopConverter has no effect.
type NopConverter struct{}

func (c *NopConverter) Convert(dst io.Writer, src io.Reader) error {
	_, err := io.Copy(dst, src)
	return err
}

func GetConverter(urlPathStr string) Converter {
	switch strings.TrimPrefix(strings.ToLower(urlPathStr), PathPrefix) {
	case "png":
		return &PngConverter{}
	default:
		return &NopConverter{}
	}
}
