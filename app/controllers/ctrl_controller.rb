class CtrlController < ApplicationController
  require 'kconv'

  def para
    render text: 'idパラメータ: ' + params[:id]
  end

  def para_array
    render text: 'categoryパラメータ : ' + params[:category].inspect
  end

  def req_head
    render text: request.headers['User-Agent']
  end

  def req_head2
    @headers = request.headers
  end

  def upload_process
    file = params[:upfile]
    name = file.original_filename
    perms = ['.jpg', '.jpeg', '.gif', '.png']
    if !perms.include?(File.extname(name).downcase)
      result = 'アップロードできるのは画像ファイルのみです'
    elsif file.size > 1.megabyte
      result = 'ファイルサイズは1MBまでです'
    else
      # winの時のみ
      # name = name.kconv(Kconv::SJIS, Kconv::UTF8)
      File.open("public/docs/#{name}", 'wb'){ |f| f.write(file.read) }
      # result = "#{name.toutf8}をアップロードしました"
      result = "#{name}をアップロードしました"
    end
    render text: result
  end

  def updb
    @author = Author.find(params[:id])
  end

  def updb_process
    @author = Author.find(params[:id])
    if @author.update(params.require(:author).permit(:data))
      render text: '保存に成功しました'
    else
      render text: @author.errors.full_messages[0]
    end
  end

  def get_xml
    @books = Book.all
    render xml: @books
  end

  def get_json
    @books = Book.all
    render json: @books
  end
end
