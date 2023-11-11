package converter

import (
	"errors"
	"io"
	"strings"

	"github.com/task4233/pgo-test/internal/domain/repository"
)

const PathPrefix = "/convert/"

var (
	ErrDecode = errors.New("failed to decode")
	ErrEncode = errors.New("failed to encode")

	_ repository.Converter = (*NopConverter)(nil)
)

// NopConverter has no effect.
type NopConverter struct{}

func (c *NopConverter) Convert(dst io.Writer, src io.Reader) error {
	_, err := io.Copy(dst, src)
	return err
}

func GetConverter(urlPathStr string) repository.Converter {
	switch strings.TrimPrefix(strings.ToLower(urlPathStr), PathPrefix) {
	case "png":
		return &PngConverter{}
	case "gif":
		return &GifConverter{}
	default:
		return &NopConverter{}
	}
}
