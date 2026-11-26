-- =====================================================
--  StakeV - bảng riêng (chạy SAU file SQL của ESX Legacy)
--  Bảng `users`, `jobs`, `job_grades`, `owned_vehicles`... do ESX tạo.
-- =====================================================

-- Hồ sơ mở rộng cho mỗi nhân vật ESX
CREATE TABLE IF NOT EXISTS `stakev_profiles` (
  `identifier`       VARCHAR(60)  NOT NULL,
  `level`            INT          NOT NULL DEFAULT 1,
  `exp`              INT          NOT NULL DEFAULT 0,
  `playtime_minutes` INT          NOT NULL DEFAULT 0,
  `vip_until`        DATETIME     NULL,
  `donate_coins`     INT          NOT NULL DEFAULT 0,
  `phone_number`     VARCHAR(10)  NULL UNIQUE,
  `created_at`       DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login`       DATETIME     NULL,
  PRIMARY KEY (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Log hành động (admin, giao dịch, vào/ra...)
CREATE TABLE IF NOT EXISTS `stakev_logs` (
  `id`         BIGINT       NOT NULL AUTO_INCREMENT,
  `category`   VARCHAR(32)  NOT NULL,
  `identifier` VARCHAR(60)  NULL,
  `message`    TEXT         NOT NULL,
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_category` (`category`),
  KEY `idx_identifier` (`identifier`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- Giai đoạn 2: Tổ chức (fraction) ----------
-- Fraction nhà nước (LSPD, EMS, Chính phủ...) dùng job của ESX.
-- Bảng dưới cho tổ chức tự lập: băng đảng, mafia, gia đình.
CREATE TABLE IF NOT EXISTS `stakev_organizations` (
  `id`         INT          NOT NULL AUTO_INCREMENT,
  `name`       VARCHAR(50)  NOT NULL UNIQUE,
  `type`       ENUM('gang','mafia','family','business') NOT NULL DEFAULT 'gang',
  `leader`     VARCHAR(60)  NOT NULL,
  `money`      BIGINT       NOT NULL DEFAULT 0,
  `color`      VARCHAR(7)   NOT NULL DEFAULT '#ff4fa3',
  `created_at` DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `stakev_organization_members` (
  `organization_id` INT         NOT NULL,
  `identifier`      VARCHAR(60) NOT NULL,
  `rank`            TINYINT     NOT NULL DEFAULT 1,
  `joined_at`       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`identifier`),
  KEY `idx_org` (`organization_id`),
  CONSTRAINT `fk_org_member` FOREIGN KEY (`organization_id`) REFERENCES `stakev_organizations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- Giai đoạn 2: Nhà ----------
CREATE TABLE IF NOT EXISTS `stakev_houses` (
  `id`        INT          NOT NULL AUTO_INCREMENT,
  `label`     VARCHAR(60)  NOT NULL,
  `class`     ENUM('trailer','econom','standard','premium','luxury','mansion') NOT NULL DEFAULT 'standard',
  `price`     INT          NOT NULL,
  `owner`     VARCHAR(60)  NULL,
  `locked`    TINYINT(1)   NOT NULL DEFAULT 1,
  `entrance`  JSON         NOT NULL,   -- {x,y,z,h}
  `garage`    JSON         NULL,
  `interior`  VARCHAR(40)  NOT NULL,   -- id interior/IPL
  `garage_slots` TINYINT   NOT NULL DEFAULT 1,
  `tax_paid_until` DATETIME NULL,
  PRIMARY KEY (`id`),
  KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- Giai đoạn 3: Doanh nghiệp ----------
CREATE TABLE IF NOT EXISTS `stakev_businesses` (
  `id`        INT          NOT NULL AUTO_INCREMENT,
  `label`     VARCHAR(60)  NOT NULL,
  `type`      ENUM('shop','gas','clothes','barber','tattoo','ammu','carshop','bar','other') NOT NULL,
  `price`     INT          NOT NULL,
  `owner`     VARCHAR(60)  NULL,
  `balance`   BIGINT       NOT NULL DEFAULT 0,
  `stock`     INT          NOT NULL DEFAULT 0,
  `markup`    TINYINT      NOT NULL DEFAULT 100, -- % giá bán
  `position`  JSON         NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_owner` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ---------- Giai đoạn 4: Battle pass ----------
CREATE TABLE IF NOT EXISTS `stakev_battlepass` (
  `identifier` VARCHAR(60) NOT NULL,
  `season`     SMALLINT    NOT NULL,
  `level`      SMALLINT    NOT NULL DEFAULT 0,
  `exp`        INT         NOT NULL DEFAULT 0,
  `premium`    TINYINT(1)  NOT NULL DEFAULT 0,
  `claimed`    JSON        NULL,      -- danh sách cấp đã nhận
  PRIMARY KEY (`identifier`, `season`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
