require 'pry-byebug'

# メソッドの引数の型を説明するコメントのフォーマットを揃えるためのスクリプト
# 下記のフォーマットに整形する
# `# @param param_name [type] description`

# rubyのファイルのみを対象にする
under_app_dir_filenames = Dir.glob('./app/*/**/**.rb')

under_app_dir_filenames.each do |name|
  need_changed = false

  File.open(name, 'r') do |file|
    file_content = file.read

    need_changed = true if file_content.include?('@params [') || file_content.include?('@param [')
  end

  next unless need_changed

  # 変更対象のファイルだった場合は、
  # tmpなファイルに対して現行ファイルを一行ずつ入れていく
  # その際に行に `@params [` OR `@param [` という文字列が含まれていた場合は
  # `# @param param_name [type] description` というフォーマットになるように整形した上で
  # tmpファイルに行を入れる
  File.open('./tmp.rb', 'w') do |tmp_file|
    File.open(name, 'r') do |file|
      file.each_line do |line|
        if line.include?('@params [') || line.include?('@param [')
          # `#` 以降を削除してインデントを保持しておく
          indent = line.sub(/#.*/, '')

          # ary is like -> ['#', '@param or @params', '[type]', 'param_name', 'description']
          ary = line.split
          ary.map! do |str|
            if str == '@params'
              # @params is replaced with @param
              '@param'
            else
              str
            end
          end
          # [type] と 引数名 を入れ替える
          # before: ['#', '@param or @params', '[type]', 'param_name', 'description']
          # after:  ['#', '@param or @params', 'param_name', '[type]' 'description']
          #
          # 順番依存しているけどめんどくさいからこのままで...w
          ary[2], ary[3] = ary[3], ary[2]

          tmp_file.puts((indent.chomp + ary.join(' ').chomp))
        else
          tmp_file.puts(line.chomp)
        end
      end
    end
  end

  # 最後に現行ファイルを削除し、descriptionコメントを修正したtmpをファイルをリネームする
  FileUtils.rm(name)
  File.rename('./tmp.rb', name)
end
