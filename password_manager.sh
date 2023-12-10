

is_add_password () {
  [ "${choice}" = "Add Password" ]
}

decrypt_handler () {
  encrypted_file="$1"

  if [ -e "${encrypted_file}" ]; then
    decrypted_file="$2"
    key_file="$3"
    iteration_count="$4"

    openssl enc -aes-256-cbc -d -in "${encrypted_file}" -kfile "${key_file}" -iter "${iteration_count}" > "${decrypted_file}" -md md5
    decrypted_data=$(< "${decrypted_file}")
    rm "${decrypted_file}"

    echo "${decrypted_data}"
  fi
}

add_password_handler () {
  password_manager_data_file="$1"
  decrypted_data="$2"

  read -p "サービス名を入力してください：" service_name
  read -p "ユーザー名を入力してください：" user_name
  read -p "パスワードを入力してください：" password

  if [ -n "${decrypted_data}" ]; then
    echo  "$decrypted_data" > "${password_manager_data_file}"
  fi
  echo $service_name:$user_name:$password >> "${password_manager_data_file}"


  echo "パスワードの追加は成功しました。"
}

encrypt_handler (){
  password_manager_data_file="$1"
  encrypted_file="$2"
  key_file="$3"
  iteration_count="$4"

  openssl enc -aes-256-cbc -e -in "${password_manager_data_file}" -kfile "${key_file}" -iter "${iteration_count}" > "${encrypted_file}" -md md5
  rm "${password_manager_data_file}"
}


add_password_service(){
  password_manager_data_file="$1"
  encrypted_file="$2"
  decrypted_file="$3"
  aes_key_file="$4"
  iteration_count="$5"

  decrypted_data=$(decrypt_handler "${encrypted_file}" "${decrypted_file}" "${aes_key_file}" "${iteration_count}")

  add_password_handler $password_manager_data_file "$decrypted_data"
  encrypt_handler $password_manager_data_file $encrypted_file $aes_key_file $iteration_count
}

is_get_password () {
 [ "${choice}" = "Get Password" ]
}

get_password_handler () {
  decrypted_data="$1"
  read -p "サービス名を入力してください：" service_name
  is_service_name=false

  echo $decrypted_data

  echo "$decrypted_data" | {
    while IFS= read -r line ; do
      if [ "$(echo "$line" | cut -d ":" -f 1)" = "$service_name" ]; then
        echo "サービス名:${service_name}"
        echo "ユーザー名:$(echo "$line" | cut -d ":" -f 2)"
        echo "パスワード:$(echo "$line" | cut -d ":" -f 3)\n"
        is_service_name=true
        break
      fi
    done

  if [ "$is_service_name" = "false" ]; then
    echo "そのサービスは登録されていません。\n"
  fi
  }


}

get_password_service () {
  encrypted_file=$1
  decrypted_file=$2
  aes_key=$3
  iteration_count=$4
  decrypted_data=$(decrypt_handler "${encrypted_file}" "${decrypted_file}" "${aes_key_file}" "${iteration_count}")
  get_password_handler "$decrypted_data"
}

is_exit () {
  [ "${choice}" = "Exit" ]
}

main () {
  password_manager_data_file="password_manager_database.dat"
  encrypted_file="password_manager_database.dat.enc"
  decrypted_file="decrypted_data.txt"
  aes_key_file="shared.aeskey"
  iteration_count=10000

  if ! command -v openssl > /dev/null 2>&1; then
    echo "opensslコマンドがインストールされていません。"
    exit 1
  fi

  if [ ! -e $aes_key_file ]; then
    openssl rand -base64 32 > $aes_key_file
    echo "暗号化と復号化のための鍵を生成しました。"
  fi

  echo "パスワードマネージャーへようこそ！"

  while true
  do
    read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" choice
    if is_add_password; then
      add_password_service $password_manager_data_file $encrypted_file $decrypted_file $aes_key_file $iteration_count
    elif is_get_password; then
      get_password_service $encrypted_file $decrypted_file $aes_key_file $iteration_count
    elif is_exit; then
      echo "Thank you!"
      exit
    else
      echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
    fi
  done
}

main
