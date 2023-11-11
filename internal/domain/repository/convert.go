package repository

import (
	"io"
)

type Converter interface {
	Convert(dst io.Writer, src io.Reader) error
}
