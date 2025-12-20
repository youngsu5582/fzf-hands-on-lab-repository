function command_switch() {
  read -n 1 -p "명령어를 입력해주세요 (a)pply, (p)op, (d)rop: " command
  echo
  case "$command" in
    a|A)
      echo "apply 가 선택되었습니다"
      ;;
    p|P)
      echo "pop 가 선택되었습니다"
      ;;
    d|D)
      echo "drop 이 선택되었습니다"
      ;;
    *)
      echo "아무것도 선택되지 않았습니다"
  esac
}