--#######################################
--          PUBLIC USERS SCHEMA
--#######################################

-- public.users definition
create table public.users (
	id varchar(255) primary key,
    created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- public.users security policies
alter table public.users enable row level security;

create policy "User profiles are viewable by all authed users."
    on public.users for select
    using ( auth.role() = 'authenticated' );

create policy "Users can insert their own profile."
    on public.users for insert
    with check ( auth.uid() = id );

create policy "Users can update their own profile."
    on public.users for update
    using ( auth.uid() = id );


--#######################################
--          PUBLIC DIDS SCHEMA
--#######################################

-- public.dids definition
create table public.dids (
    user_id varchar(255) primary key references public.users not null,
    domain varchar(255) unique not null,
    "provider" varchar(255) not null,
    email varchar(255) null,
    "url" varchar(255) null,
    avatar varchar(255) null,
    "name" varchar(255) null,
    "description" text null
);
create index did_name_idx on public.dids using btree ("domain");

-- public.dids security policies
alter table public.dids enable row level security;

create policy "DIDs are viewable by all authed users."
    on public.dids for select
    using ( auth.role() = 'authenticated' );

create policy "Users can insert their own DIDs."
    on public.dids for insert
    with check ( auth.uid() = user_id );

create policy "Users can update their own DIDs."
    on public.dids for update
    using ( auth.uid() = user_id );
