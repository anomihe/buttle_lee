BEGIN;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "household" ADD COLUMN "isFocusActive" boolean NOT NULL DEFAULT false;
ALTER TABLE "household" ADD COLUMN "focusEndTime" timestamp without time zone;
ALTER TABLE "household" ADD COLUMN "focusMode" text;
ALTER TABLE "household" ADD COLUMN "focusStartedBy" bigint;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "shared_routine" (
    "id" bigserial PRIMARY KEY,
    "householdId" bigint NOT NULL,
    "createdBy" bigint NOT NULL,
    "name" text NOT NULL,
    "tasks" json NOT NULL,
    "sharedAt" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "household_routine_idx" ON "shared_routine" USING btree ("householdId");

--
-- ACTION ALTER TABLE
--
ALTER TABLE "user_profile" ADD COLUMN "focusCompleted" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_profile" ADD COLUMN "focusGivenUp" bigint NOT NULL DEFAULT 0;
ALTER TABLE "user_profile" ADD COLUMN "hydrationInterval" bigint NOT NULL DEFAULT 60;
ALTER TABLE "user_profile" ADD COLUMN "journalReminder" boolean NOT NULL DEFAULT false;
ALTER TABLE "user_profile" ADD COLUMN "journalInterval" bigint NOT NULL DEFAULT 24;
ALTER TABLE "user_profile" ADD COLUMN "bookReminder" boolean NOT NULL DEFAULT false;
ALTER TABLE "user_profile" ADD COLUMN "bookInterval" bigint NOT NULL DEFAULT 24;
ALTER TABLE "user_profile" ADD COLUMN "focusModeDuration" bigint NOT NULL DEFAULT 25;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_auth_idp_firebase_account" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "authUserId" uuid NOT NULL,
    "created" timestamp without time zone NOT NULL,
    "email" text,
    "phone" text,
    "userIdentifier" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_auth_firebase_account_user_identifier" ON "serverpod_auth_idp_firebase_account" USING btree ("userIdentifier");

--
-- ACTION ALTER TABLE
--
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_domain";
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_source";
DROP INDEX "serverpod_auth_idp_rate_limited_request_attempt_nonce";
CREATE INDEX "serverpod_auth_idp_rate_limited_request_attempt_composite" ON "serverpod_auth_idp_rate_limited_request_attempt" USING btree ("domain", "source", "nonce", "attemptedAt");
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_firebase_account"
    ADD CONSTRAINT "serverpod_auth_idp_firebase_account_fk_0"
    FOREIGN KEY("authUserId")
    REFERENCES "serverpod_auth_core_user"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR my_butler
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('my_butler', '20260127162132761', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260127162132761', "timestamp" = now();

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
