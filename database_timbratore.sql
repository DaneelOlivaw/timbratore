-- phpMyAdmin SQL Dump
-- version 2.11.3deb1ubuntu1.1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generato il: 08 Apr, 2009 at 02:50 PM
-- Versione MySQL: 5.0.51
-- Versione PHP: 5.2.4-2ubuntu5.5

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `stamping`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `stamps`
--

CREATE TABLE IF NOT EXISTS `stamps` (
  `id` int(11) NOT NULL auto_increment,
  `users_id` int(11) NOT NULL,
  `matricola` varchar(10) NOT NULL,
  `ora` timestamp NOT NULL default CURRENT_TIMESTAMP,
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dump dei dati per la tabella `stamps`
--


-- --------------------------------------------------------

--
-- Struttura della tabella `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL auto_increment,
  `matricola` varchar(10) NOT NULL,
  `nome` varchar(50) NOT NULL,
  `password` varchar(10) NOT NULL,
  PRIMARY KEY  (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

--
-- Dump dei dati per la tabella `users`
--

