# param_type_comment_formatter

Rubyを使ってると型がほしいいいってなる時がある。
そんな時にメソッドに対して引数や戻り値の型をコメントで入れたりすることがある。

```rb
# @param money [Integer] forwardさせたいmoney
#
# @return [Integer] 2倍化されたmoney
def forward_money(money:)
  money * 2
end
```

👆みたいなコメントをコードに入れてると `@param` なのか `@params` なのかわからなくなって、`@param` と `@params` が両方乱立しててカオス＼(^o^)／

フォーマットも `@param param_name [type] description` なのか `@param [type]  param_name description` なのかわからなくなって、両方乱立しててカオス＼(^o^)／

直そう
