#!/bin/bash
set -euo pipefail

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<'SQL'
CREATE DATABASE IF NOT EXISTS seata DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS seata_order DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE DATABASE IF NOT EXISTS seata_product DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
SQL

mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" seata < /docker-entrypoint-initdb.d/sql/seata.sql
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" seata_order < /docker-entrypoint-initdb.d/sql/seata_order.sql
mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" seata_product < /docker-entrypoint-initdb.d/sql/seata_product.sql
