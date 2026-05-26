package postgres

import "gorm.io/gorm"

// NewConnection returns nil for now (in-memory mode)
// Will be restored when Postgres is added back
func NewConnection(dsn string) (*gorm.DB, error) {
	return nil, nil
}
