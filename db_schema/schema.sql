create table blog_post
(
  id      bigserial not null
    constraint blog_post_pkey
    primary key,
  title   text default '' :: text,
  content text default '' :: text
);

alter table blog_post
  owner to postgres;

create table typist_user
(
  id       bigserial not null
    constraint user_pkey
    primary key,
  username text      not null,
  email    text      not null,
  password text      not null
);

alter table typist_user
  owner to postgres;

create unique index user_username_uindex
  on typist_user (username);

create unique index user_email_uindex
  on typist_user (email);

create table typist_session
(
  id      text   not null
    constraint session_pkey
    primary key,
  user_id bigint not null
    constraint session_user_user_id_fk
    references typist_user
);

alter table typist_session
  owner to postgres;

create table book
(
  id    bigserial not null
    constraint book_pkey
    primary key,
  title text      not null
);

alter table book
  owner to postgres;

create table typist_text
(
  id            bigserial not null
    constraint text_pkey
    primary key,
  title         text      not null,
  content       text      not null,
  book_id       bigint
    constraint typing_text_book_id_fk
    references book,
  index_in_book int
);

alter table typist_text
  owner to postgres;

create table text_wpm
(
  id      bigserial not null
    constraint text_wpm_pkey
    primary key,
  wpm     decimal,
  text_id bigint
    constraint text_wpm_text_id_fk
    references typist_text,
  user_id bigint
    constraint text_wpm_user_id_fk
    references typist_user
);

alter table text_wpm
  owner to postgres;

create table word_wpm
(
  id      bigserial not null
    constraint word_wpm_pkey
    primary key,
  wpm     decimal,
  text_wpm_id bigint
    constraint word_wpm_text_wpm_id_fk
    references text_wpm,
  user_id bigint
    constraint word_wpm_user_id_fk
    references typist_user
);

alter table word_wpm
  owner to postgres;

create table letter_wpm
(
  id      bigserial not null
    constraint letter_wpm_pkey
    primary key,
  wpm     decimal,
  text_wpm_id bigint
    constraint letter_wpm_text_wpm_id_fk
    references text_wpm,
  user_id bigint
    constraint letter_wpm_user_id_fk
    references typist_user
);

alter table letter_wpm
  owner to postgres;
