package converter

import (
	"image"
	"image/draw"
	"image/jpeg"
	"image/png"
	"io"

	"github.com/task4233/pgo-test/internal/domain/repository"
	xdraw "golang.org/x/image/draw"
)

var _ repository.Converter = (*PngConverter)(nil)

type PngConverter struct{}

func (c *PngConverter) Convert(dst io.Writer, src io.Reader) error {
	// decode the data
	// assume the given data extension is jpeg
	imgData, err := jpeg.Decode(src)
	if err != nil {
		return ErrDecode
	}

	// change image size
	imgSrc := imgData.Bounds()
	imgDst := image.NewRGBA(image.Rect(0, 0, imgSrc.Dx()/4, imgSrc.Dy()/4))
	xdraw.CatmullRom.Scale(imgDst, imgDst.Bounds(), imgData, imgSrc, draw.Over, nil)

	// encode to png
	err = png.Encode(dst, imgDst)
	if err != nil {
		return ErrEncode
	}

	return nil
}
