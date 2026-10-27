# seata-demo

Seata 1.0 AT / TCC 下单示例，包含商品服务、订单服务和聚合服务。业务代码依赖 [dk-foundation 的 dev-seata 分支](https://github.com/dk-lockdown/dk-foundation/tree/dev-seata)。

## Docker Compose 运行

需要本机已安装 Docker，并使用 `docker compose`（不是 `docker-compose`）。请先确认宿主机端口 `3306`、`8091`、`3001`、`3002`、`3003` 未被占用。

在仓库根目录执行：

```bash
docker compose up -d --build
```

首次构建会下载基础镜像、Seata Server 1.0.0，并拉取 `dk-foundation` 的 `dev-seata` 分支安装为 `2.1.1-SNAPSHOT`，再打包三个服务。这一步耗时较长。

查看状态：

```bash
docker compose ps
docker compose logs -f order-aggregation-service
```

服务就绪后调用聚合服务：

```bash
# TCC
curl http://localhost:3003/aggregation/v1/order/create

# AT
curl http://localhost:3003/aggregation/v1/order/create2
```

| 服务 | 地址 | 说明 |
| --- | --- | --- |
| MySQL 5.7 | `localhost:3306` | 库 `seata`、`seata_order`、`seata_product`，账号 `root` / `123456`。Seata 1.0 自带的驱动不兼容 MySQL 8 |
| Seata Server | `localhost:8091` | 会话存储为 db 模式 |
| product-service | `http://localhost:3001/product` | 商品与库存 |
| order-service | `http://localhost:3002/order` | 订单 |
| order-aggregation-service | `http://localhost:3003/aggregation` | 发起全局事务 |

停止并保留数据库数据：

```bash
docker compose down
```

连同 MySQL 数据卷一起删除：

```bash
docker compose down -v
```

修改初始化 SQL 后需要重建数据卷，否则 `docker-entrypoint-initdb.d` 不会再次执行：

```bash
docker compose down -v
docker compose up -d --build
```

## 本地运行

不使用容器时，按下面的顺序准备环境：

1. 编译并安装 [dk-foundation 的 dev-seata 分支](https://github.com/dk-lockdown/dk-foundation/tree/dev-seata)。上游模块版本是 `2.1-SNAPSHOT`，本仓库依赖 `2.1.1-SNAPSHOT`，安装前需要把该分支里的版本号改成 `2.1.1-SNAPSHOT`。
2. 启动 MySQL，账号 `root` / `123456`，执行 `product-service/script/seata_product.sql`、`order-service/script/seata_order.sql`，并按 Seata 1.0 的 db 模式建库 `seata`（脚本见 `docker/mysql/seata.sql`）。
3. 启动 Seata Server 1.0.0，把 `store.mode` 改为 `db`，并指向上面的 `seata` 库。
4. 分别启动三个服务：`product-service`、`order-service`、`order-aggregation-service`。

未设置环境变量时，数据源仍连接 `127.0.0.1:3306`，聚合服务仍访问 `localhost:3001` 和 `localhost:3002`。
