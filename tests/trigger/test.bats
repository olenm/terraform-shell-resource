load ../helper

@test "changes on each destroy/apply" {
  runner "terraform apply -auto-approve"
  tf_output ".output.value.stdout"
  local first=$output

  runner "terraform destroy -force"
  runner "terraform apply -auto-approve"

  tf_output ".output.value.stdout"
  local second=$output
  assert_not "$first" "$second"
}

@test "does not change with apply+apply" {
  runner "terraform apply -auto-approve"

  tf_output ".output.value.stdout"
  local first=$output

  runner "terraform apply -auto-approve"

  tf_output ".output.value.stdout"
  local second=$output
  assert "$first" "$second"
}

@test "changes when trigger changes apply+apply" {
  tf_output ".output.value.stdout"
  local first=$output

  runner "terraform apply -auto-approve -var trigger=999"
  tf_output ".output.value.stdout"
  local second=$output

  assert_not "$first" "$second"
}
