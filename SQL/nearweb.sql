-- NEARWEB SQL © 2023

-- THE BASICS
-- --------------------------------------------------------

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";

-- EVERYTHING PATREON TIERS
-- --------------------------------------------------------

CREATE TABLE `tier_squire` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `tier_tiamat` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `tier_marduk` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `tier_crusader` (
  `ckey` char(30) NOT NULL
);

-- EVERYTHING ADMINS
-- --------------------------------------------------------

CREATE TABLE `admins` (
  `ckey` varchar(255) NOT NULL PRIMARY KEY,
  `rank` int(1) NOT NULL
);

CREATE TABLE `adminsfarweb` (
  `ckey` varchar(30) DEFAULT NULL
);

-- EVERYTHING BANS
-- --------------------------------------------------------

CREATE TABLE `bans` (
  `ckey` varchar(255) NOT NULL PRIMARY KEY,
  `computerid` text NOT NULL,
  `ips` varchar(255) NOT NULL,
  `reason` text NOT NULL,
  `bannedby` varchar(255) NOT NULL,
  `temp` int(1) NOT NULL COMMENT '0 = perma ban / minutes banned',
  `minute` int(255) NOT NULL DEFAULT 0,
  `timebanned` timestamp NOT NULL DEFAULT current_timestamp()
);

CREATE TABLE `bansfarweb` (
  `ckey` varchar(30) NOT NULL,
  `reason` text NOT NULL,
  `adminckey` varchar(30) NOT NULL,
  `isbanned` tinyint(4) DEFAULT NULL
);

-- EVERYTHING BOOKS
-- --------------------------------------------------------

CREATE TABLE `booklog` (
  `ckey` varchar(255) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'INSERT',
  `title` text NOT NULL,
  `author` varchar(256) NOT NULL,
  `text` longtext NOT NULL,
  `cat` int(11) NOT NULL
);

CREATE TABLE `books` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `text` longtext NOT NULL,
  `cat` int(2) NOT NULL DEFAULT 1
);

-- EVERYTHING CHANGELOG
-- --------------------------------------------------------

CREATE TABLE `changelog` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `bywho` varchar(255) NOT NULL,
  `changes` text NOT NULL,
  `date` timestamp NOT NULL DEFAULT current_timestamp()
);

-- EVERYTHING ACCESS
-- --------------------------------------------------------

CREATE TABLE `access_lord` (
  `ckey` char(30) NOT NULL
);

INSERT INTO `access_lord` (`ckey`) VALUES
('raiddean');

CREATE TABLE `access_villain` (
  `ckey` varchar(30) NOT NULL
);

CREATE TABLE `access_comrade` (
  `ckey` varchar(30) NOT NULL
);

INSERT INTO `access_comrade` (`ckey`) VALUES
('raiddean'),
('coroneljones'),
('alanii'),
('benblu'),
('systemcheck');

CREATE TABLE `access_pigplus` (
  `ckey` varchar(30) NOT NULL
);

-- EVERYTHING CONFIGURATION
-- --------------------------------------------------------

CREATE TABLE `config` (
  `motd` text NOT NULL
);

-- EVERYTHING LIBRARY
-- --------------------------------------------------------

CREATE TABLE `erro_library` (
  `sqltitle` varchar(50) NOT NULL,
  `sqlauthor` varchar(50) NOT NULL,
  `sqlcontent` longtext NOT NULL,
  `sqlcategory` varchar(15) NOT NULL
);

-- EVERYTHING DONATIONS
-- --------------------------------------------------------

CREATE TABLE `donation_futa` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_trap` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_30cm` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_lecheryamulet` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_crusader` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_mobilephone` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_remigrator` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_monk` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_outlaw` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_mercenary` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_seaspotter` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_reddawn` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_waterbottle` (
  `ckey` char(30) NOT NULL
);

CREATE TABLE `donation_mycolor` (
  `ckey` char(30) NOT NULL
);

INSERT INTO `donation_lecheryamulet` (`ckey`) VALUES
('raiddean');

INSERT INTO `donation_outlaw` (`ckey`) VALUES
('raiddean');

INSERT INTO `donation_mercenary` (`ckey`) VALUES
('raiddean');

-- EVERYTHING JOBBAN
-- --------------------------------------------------------

CREATE TABLE `jobban` (
  `ckey` varchar(255) NOT NULL,
  `rank` varchar(255) NOT NULL
);

CREATE TABLE `jobbanlog` (
  `ckey` varchar(255) NOT NULL COMMENT 'By who',
  `targetckey` varchar(255) NOT NULL COMMENT 'Target',
  `rank` varchar(255) NOT NULL COMMENT 'rank',
  `when` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'when',
  `why` varchar(355) NOT NULL
);

-- EVERYTHING MEDALS
-- --------------------------------------------------------

CREATE TABLE `medals` (
  `ckey` varchar(255) NOT NULL,
  `medal` text NOT NULL,
  `medaldesc` text NOT NULL,
  `medaldiff` text NOT NULL
);

-- EVERYTHING PLAYERS
-- --------------------------------------------------------

CREATE TABLE `players` (
  `ckey` varchar(255) NOT NULL,
  `slot` int(2) NOT NULL DEFAULT 1,
  `slotname` varchar(255) NOT NULL DEFAULT 'Default',
  `real_name` varchar(255) NOT NULL,
  `gender` varchar(255) NOT NULL,
  `occupation1` varchar(255) NOT NULL,
  `occupation2` varchar(255) NOT NULL,
  `occupation3` varchar(255) NOT NULL,
  `hair_red` int(3) NOT NULL,
  `hair_green` int(3) NOT NULL,
  `hair_blue` int(3) NOT NULL,
  `ages` int(3) NOT NULL,
  `facial_red` int(3) NOT NULL,
  `facial_green` int(3) NOT NULL,
  `facial_blue` int(3) NOT NULL,
  `skin_tone` int(3) NOT NULL,
  `hair_style_name` varchar(255) NOT NULL,
  `facial_style_name` varchar(255) NOT NULL,
  `eyes_red` int(3) NOT NULL,
  `eyes_green` int(3) NOT NULL,
  `eyes_blue` int(3) NOT NULL,
  `blood_type` varchar(3) NOT NULL,
  `be_syndicate` int(3) NOT NULL,
  `underwear` int(3) NOT NULL,
  `name_is_always_random` int(3) NOT NULL,
  `bios` longtext NOT NULL,
  `show` int(1) NOT NULL DEFAULT 1,
  `be_nuke_agent` tinyint(1) NOT NULL,
  `be_takeover_agent` tinyint(1) NOT NULL
);

CREATE TABLE `playersfarweb` (
  `ckey` char(30) NOT NULL PRIMARY KEY,
  `firstseen` datetime DEFAULT NULL,
  `lastseen` datetime DEFAULT NULL,
  `invitedby` char(30) DEFAULT NULL,
  `invitecount` smallint(6) NOT NULL DEFAULT 0,
  `reason` longtext DEFAULT NULL,
  `chromosomes` int(11) DEFAULT 0
);

INSERT INTO `playersfarweb` (`ckey`, `firstseen`, `lastseen`, `invitedby`, `invitecount`, `reason`, `chromosomes`) VALUES
('alanii', NULL, NULL, 'God-Empress', 0, NULL, 0),
('raiddean', NULL, NULL, 'God-Empress', 0, NULL, 0),
('benblu', NULL, NULL, 'God-Empress', 0, NULL, 0),
('coroneljones', NULL, NULL, 'God-Empress', 0, NULL, 0),
('systemcheck', NULL, NULL, 'God-Empress', 0, NULL, 0);

-- EVERYTHING PLAYER REPUTATION
-- --------------------------------------------------------

CREATE TABLE `reputation` (
  `ckey` varchar(30) DEFAULT NULL,
  `giver_ckey` varchar(30) DEFAULT NULL,
  `value` tinyint(1) DEFAULT NULL,
  `reason` mediumtext DEFAULT NULL
);

-- EVERYTHING STORIES
-- --------------------------------------------------------

CREATE TABLE `stories` (
  `storyid` bigint(20) NOT NULL DEFAULT 0
);

INSERT INTO `stories` (`storyid`) VALUES
(1);

-- EVERYTHING TRAITORLOGS
-- --------------------------------------------------------

CREATE TABLE `traitorlogs` (
  `CKey` varchar(128) NOT NULL,
  `Objective` text NOT NULL,
  `Succeeded` tinyint(4) NOT NULL,
  `Spawned` text NOT NULL,
  `Occupation` varchar(128) NOT NULL,
  `PlayerCount` int(11) NOT NULL
);

-- EVERYTHING UNBANS
-- --------------------------------------------------------

CREATE TABLE `unbans` (
  `ckey` varchar(255) NOT NULL,
  `computerid` text NOT NULL,
  `ips` varchar(255) NOT NULL,
  `reason` text NOT NULL,
  `bannedby` varchar(255) NOT NULL,
  `temp` int(255) NOT NULL COMMENT '0 = perma ban / minutes banned',
  `minutes` int(255) NOT NULL,
  `timebanned` timestamp NOT NULL DEFAULT current_timestamp()
);

-- EVERYTHING UNIQUE KEYS
-- --------------------------------------------------------

ALTER TABLE `jobban`
  ADD UNIQUE KEY `NODUPES` (`ckey`(100),`rank`(100));

ALTER TABLE `jobbanlog`
  ADD UNIQUE KEY `targetckey` (`targetckey`(100),`rank`(100));

ALTER TABLE `medals`
  ADD UNIQUE KEY `NODUPES` (`ckey`,`medal`(8));

ALTER TABLE `players`
  ADD UNIQUE KEY `ckey` (`ckey`,`slot`);

-- EVERYTHING FOREIGN KEYS
-- --------------------------------------------------------

ALTER TABLE `adminsfarweb`
  ADD CONSTRAINT `ckey` FOREIGN KEY (`ckey`) REFERENCES `playersfarweb` (`ckey`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;
