BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "butler_reminder" ADD COLUMN "assignedToUserId" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "household" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "joinCode" text NOT NULL,
    "adminId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "joinCode_idx" ON "household" USING btree ("joinCode");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "household_member" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "userId" bigint NOT NULL,
    "role" text NOT NULL,
    "joinedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "household_user_idx" ON "household_member" USING btree ("householdId", "userId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_profile" ADD COLUMN "xp" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_profile" ADD COLUMN "level" bigint NOT NULL DEFAULT 1;

--
-- MIGRATION VERSION FOR my_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('my_butler', '20260119162839682', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260119162839682', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
