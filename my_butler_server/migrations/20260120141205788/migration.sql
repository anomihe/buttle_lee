BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_profile" ADD COLUMN "hydrationGoal" bigint NOT NULL DEFAULT 8;
ALTER TABLE "user_profile" ADD COLUMN "hydrationCount" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_profile" ADD COLUMN "hydrationDate" text;
ALTER TABLE "user_profile" ADD COLUMN "hydrationReminder" boolean NOT NULL DEFAULT false;
ALTER TABLE "user_profile" ADD COLUMN "hydrationHistory" text;

--
-- MIGRATION VERSION FOR my_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('my_butler', '20260120141205788', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260120141205788', "timestamp" = now();

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
