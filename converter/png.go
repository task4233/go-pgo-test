package converter

import (
	"image/jpeg"
	"image/png"
	"io"
)

var _ Converter = (*PngConverter)(nil)

type PngConverter struct{}

func (c *PngConverter) Convert(dst io.Writer, src io.Reader) error {
	// decode the data
	// assume the given data extension is jpeg
	imgData, err := jpeg.Decode(src)
	if err != nil {
		return ErrDecode
	}

	// encode to png
	err = png.Encode(dst, imgData)
	if err != nil {
		return ErrEncode
	}

	return nil
}
