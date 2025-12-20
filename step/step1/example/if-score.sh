function if-score() {
  read -p "숫자를 입력해주세요 : " score
  if [ "$score" -ge 100 ]; then
    echo "100점 이상"
  elif [ "$score" -ge 50 ]; then
    echo "50점 이상 100점 이하입니다."
  else
    echo "50점 이하입니다."
  fi
}