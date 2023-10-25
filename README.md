# otus-linux-hl-2023
Administrator Linux. Advanced

## <a id="title1">Подготовка к работе с Yandex Cloud:</a>
 * Установить yc cli по [инструкции](https://cloud.yandex.ru/docs/cli/operations/install-cli)
 * Создать профиль по [инструкции](https://cloud.yandex.ru/docs/cli/operations/profile/profile-create)
 * Проверить установку и настройку yc CLI:
   ```bash
   yc config list
   ```
 * Убедиться, что профиль в состоянии ACTIVE:
   ```bash
   yc config profile list
   ```
 * Создать сервисный аккаунт:
   ```bash
   SVC_ACCT="<service_account_name>"
   ```
   ```bash
   FOLDER_ID="<get_from_yc_config_list>"
   ```
   ```bash
   yc iam service-account create --name $SVC_ACCT --folder-id $FOLDER_ID
   ```
 * Выдать права сервисному аккаунту:
   ```bash
   ACCT_ID=$(yc iam service-account get $SVC_ACCT | grep ^id | awk '{print $2}')
   ```
   ```bash
   yc resource-manager folder add-access-binding --id $FOLDER_ID --role editor --service-account-id $ACCT_ID
   ```
 * Получить IAM-токен для сервисного аккаунта:
   ```bash
   mkdir ~/keys
   ```
   ```bash
   yc iam key create --service-account-name <service_account> --output ~/keys/key.json
   ```

___

# Домашнее задание №1

<details><summary>Инструкция</summary>

### Подготовка:
 * Скачать **git** репозиторий по ссылке:
   ```bash
   git clone https://github.com/klimenko-sergey/otus-linux-hl-2023.git
   ```
 * [При необходимости выполнить подготовку к работе с Yandex Cloud](#title1)
 * Создать связку закрытого и открытого ключей:
   ```bash
   ssh-keygen -P "" -t ed25519 -f ~/.ssh/yakey
   ```
 * Перейти в директорию **terraform/lab1** репозитория **otus-linux-hl-2023**:
   ```bash
   cd otus-linux-hl-2023/terraform/lab1
   ```
 * Создать файл **terraform.tfvars** согласно шаблону **terraform.tfvars.example**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
 * Задать в **terraform.tfvars** значения перменным: *cloud_id*, *folder_id*, *public_key_path*, *service_account_key_file*

### Разворачивание инстанса ВМ с NGINX:
 * В директории **terraform/lab1** репозитория **otus-linux-hl-2023** выполнить инициализацию:
   ```bash
   terraform init
   ```
 * В том же расположении выполнить команду разворачивания:
   ```bash
   terraform apply --auto-approve
   ```

### Проверка:
 * В браузере перейти по ссылке:
   ```
   http://<external_ip_address_app>/
   ```
 * Отобразится приветственная страница NGINX со следующим текстом:

    <h1>Welcome to nginx!</h1>
    
    If you see this page, the nginx web server is successfully installed and working. Further configuration is required.
    
    For online documentation and support please refer to nginx.org.
    Commercial support is available at nginx.com.
    
    <em>Thank you for using nginx.</em>

   
### Удаление инстанса:
 * В директории **terraform/lab1** репозитория **otus-linux-hl-2023** выполнить команду удаления:
   ```bash
   terraform destroy
   ```

</details>

---

# Домашнее задание №2

<details><summary>Инструкция</summary>

### Подготовка:
 * Скачать **git** репозиторий по ссылке:
   ```bash
   git clone https://github.com/klimenko-sergey/otus-linux-hl-2023.git
   ```
 * [При необходимости выполнить подготовку к работе с Yandex Cloud](#title1)
 * Создать связку закрытого и открытого ключей:
   ```bash
   ssh-keygen -P "" -t ed25519 -f ~/.ssh/yakey
   ```
 * Перейти в директорию **terraform/lab2** репозитория **otus-linux-hl-2023**:
   ```bash
   cd otus-linux-hl-2023/terraform/lab1
   ```
 * Создать файл **terraform.tfvars** согласно шаблону **terraform.tfvars.example**:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```
 * Задать в **terraform.tfvars** значения перменным: *cloud_id*, *folder_id*, *public_key_path*, *service_account_key_file*

### Разворачивание инстансов ВМ с приложением WordPress:
 * В директории **terraform/lab2** репозитория **otus-linux-hl-2023** выполнить инициализацию:
   ```bash
   terraform init
   ```
 * В том же расположении выполнить команду разворачивания:
   ```bash
   terraform apply --auto-approve
   ```

### Проверка:
 * В браузере перейти по ссылке:
   ```
   http://<external_ip_address_app>.sslip.io/index.php
   ```
 * Отобразится страница с первичной настройкой ПО WordPress

### Удаление инстанса:
 * В директории **terraform/lab2** репозитория **otus-linux-hl-2023** выполнить команду удаления:
   ```bash
   terraform destroy --auto-approve
   ```

</details>

---