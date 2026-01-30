BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "book" ADD COLUMN "lessonsLearned" text;
ALTER TABLE "book" ADD COLUMN "isCompleted" boolean NOT NULL DEFAULT false;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "chapter" (
    "id" bigserial PRIMARY KEY,
    "bookId" bigint NOT NULL,
    "title" text NOT NULL,
    "chapterOrder" bigint NOT NULL,
    "isCompleted" boolean NOT NULL DEFAULT false,
    "completedAt" timestamp without time zone
);


--
-- MIGRATION VERSION FOR my_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('my_butler', '20260130140547020', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260130140547020', "timestamp" = now();

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
    VALUES ('serverpod_auth_idp', '20260109031533194', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260109031533194', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
