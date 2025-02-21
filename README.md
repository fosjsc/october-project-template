# 🚀 Development Setup

Follow these steps to set up your development environment quickly and efficiently.

---

## 1️⃣ Clone the Repository

Clone the project with all its submodules using:

```bash
git clone --recurse-submodules -j8 git@github.com:fosjsc/october-project-template.git <project_name>
```

---

## 2️⃣ Navigate to the Project Directory

Move into your newly cloned project:

```bash
cd <project_name>
```

---

## 3️⃣ Set Up Environment Variables

### 📂 Copy Configuration Files

Run the following commands to copy the required environment configuration files:

```bash
cp .env.example .env
cp laradock/.env.dev laradock/.env
```

### ⚙️ Configure `COMPOSE_PROJECT_NAME`

-   Open `laradock/.env` and set the `COMPOSE_PROJECT_NAME` variable to match your project name.

> [!IMPORTANT]
> Ensure that all configurations in `.env` align with those in `laradock/.env`.  
> For example, if your `COMPOSE_PROJECT_NAME` is `foobar`, and `laradock/.env` contains:
>
> ```env
> POSTGRES_DB=${COMPOSE_PROJECT_NAME}
> POSTGRES_USER=${COMPOSE_PROJECT_NAME}_uSer
> ```
>
> then in `.env`, the PostgreSQL configurations must be explicitly set as:
>
> ```env
> DB_DATABASE=foobar
> DB_USER=foobar_uSer
> ```

> [!TIP]
> For additional Laradock environment configurations, refer to:  
> [Laradock Documentation](https://laradock.io/docs/usage)

---

## 4️⃣ Configure Local DNS

Add your project’s local domain to the hosts file:

```bash
sudo nano /etc/hosts
```

Then, add this line:

```
127.0.0.1       <project_name>.test
127.0.0.1       minio-console.<project_name>.test
127.0.0.1       minio.<project_name>.test
```

---

## 5️⃣ Navigate to the `laradock` Directory

```bash
cd laradock
```

---

## 6️⃣ Set Up Nginx Configuration

Copy the example Nginx configuration file:

```bash
cp nginx/sites/octobercms.conf.example nginx/sites/octobercms.conf
cp nginx/sites/minio.conf.example nginx/sites/minio.conf
cp nginx/sites/minio-console.conf.example nginx/sites/minio-console.conf
```

> [!NOTE]
> Configuration will use port `80` and `443` as default.
> Override your port in `octobercms.conf` if you need to.

---

## 7️⃣ Start Docker Containers

Run the following command to start the necessary containers:

```bash
docker compose -f docker-compose.dev.yml up -d
```

---

## 8️⃣ Config Minio

-   Access Minio console at `https://minio-console.<project_name>.test`
-   Create a new bucket
-   Set `Access Policy` to `Custom` with following values
    ```json
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "AWS": ["*"]
                },
                "Action": [
                    "s3:ListBucket",
                    "s3:PutObject",
                    "s3:PutObjectAcl",
                    "s3:DeleteObject",
                    "s3:GetObject",
                    "s3:GetObjectAcl"
                ],
                "Resource": [
                    "arn:aws:s3:::<bucket_name>",
                    "arn:aws:s3:::<bucket_name>/*"
                ]
            }
        ]
    }
    ```
-   Create an access key
-   Open `.env` file and replace `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, `AWS_BUCKET`, `AWS_URL`

---

## 9️⃣ Access the Workspace Container

To execute commands (Artisan, Composer, PHPUnit, Gulp, etc.), enter the workspace container:

```bash
docker compose -f docker-compose.dev.yml exec -u laradock workspace bash
```

---

## 🔟 Install Dependencies

Run the following command to install Composer dependencies:

```bash
composer install
```

---

## 1️⃣1️⃣ Run OctoberCMS Migrations

Execute the migration command:

```bash
php artisan october:migrate
```

---

## 1️⃣2️⃣ Mirror OctoberCMS Files

Synchronize your OctoberCMS files:

```bash
php artisan october:mirror
```

---

## 1️⃣3️⃣ Generate Application Key

Generate a new application key:

```bash
php artisan key:generate
```

---

## 1️⃣4️⃣ Access Your Project 🎉

Once everything is set up, you can access your project at:

```
https://<project_name>.test
```

Backend default backend URI is set in `.env` as `/admin`.

```
https://<project_name>.test/admin
```

Enjoy your development environment! 🚀

---

### 🔄 Troubleshooting & Tips

-   If changes don’t reflect immediately, run:
    ```bash
    php artisan october:mirror
    ```
-   If you modify **assets, resources, or add new plugins**, run:
    ```bash
    php artisan october:mirror
    ```
-   Clear cache if needed:
    ```bash
    php artisan cache:clear
    ```
