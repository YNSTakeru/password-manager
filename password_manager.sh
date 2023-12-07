is_add_password () {
  [ "${choice}" = "Add Password" ]
}

add_password_handler () {
    read -p "サービス名を入力してください：" service_name
    read -p "ユーザー名を入力してください：" user_name
    read -p "パスワードを入力してください：" password
    echo $service_name:$user_name:$password>>password_manager_database.txt
    echo "パスワードの追加は成功しました。"
}

is_get_password () {
 [ "${choice}" = "Get Password" ]
}

add_get_password_handler () {
  read -p "サービス名を入力してください：" service_name
  is_service_name=false

  while read line
    do
      if [ `echo $line | cut -d ":" -f 1` = $service_name ]; then
      echo "サービス名:`echo $service_name`"
      echo "ユーザー名：`echo $line | cut -d ":" -f 2`"
      echo "パスワード：`echo $line | cut -d ":" -f 3`\n"
      is_service_name=true
      break
      fi
    done < password_manager_database.txt

  if [ $is_service_name = false ]; then
  echo "そのサービスは登録されていません。\n"
  fi
}

is_exit () {
  [ "${choice}" = "Exit" ]
}

main () {
  echo "パスワードマネージャーへようこそ！"
  while true
  do
    read -p "次の選択肢から入力してください(Add Password/Get Password/Exit)：" choice
    if is_add_password; then
      add_password_handler
    elif is_get_password; then
      add_get_password_handler
    elif is_exit; then
      echo "Thank you!"
      exit
    else
      echo "入力が間違えています。Add Password/Get Password/Exit から入力してください。"
    fi
  done
}

main
