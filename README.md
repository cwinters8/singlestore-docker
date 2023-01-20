# SingleStore cluster via Docker

S2 cluster configuration with local Docker, implemented for educational purposes.

## prerequisites

- local Docker installation (Docker Desktop on MacOS)
- the following files added to the root of this repository:

### `singlestorekey.pem`

can be downloaded from SingleStore google drive

```sh
wget --no-check-certificate "https://drive.google.com/uc?export=download&id=1uxawQ3weAFs1I24-lnL5Pgl2BdKAv5Gr" -O singlestorekey.pem
```

### `.env`

copy `.env.sample` to `.env` and update the LICENSE and PASSWORD variables

```sh
cp .env.sample .env
vim .env # or whatever editor you want to use
```

## running

```sh
docker compose build && docker compose up
```

## shutting down

when you want to terminate the cluster, or need a clean state to start from, run:

```sh
docker compose down
```
