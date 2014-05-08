class CtrlController < ApplicationController
  # before_action :start_logger
  before_action :auth, only: :index
  after_action :endlogger
  require 'kconv'

  def index
    sleep 3
    render text: 'indexアクションが実行されました'
  end

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

  def cookie
    @email = cookies[:email]
  end

  def cookie_rec
    cookies[:email] = { value: params[:email],
      expires: 3.months.from_now, http_only: true }
    render text: 'クッキーを保存しました'
  end

  def session_show
    @email = session[:email]
  end

  def session_rec
    session[:email] = params[:email]
    render text: 'セッションを保存しました。'
  end

  private
  def start_logger
    logger.debug('[Start] ' + Time.now.to_s)
  end

  def endlogger
    logger.debug('[Finish] ' + Time.now.to_s)
  end

  def auth
    name = 'admin'
    passwd = '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8'
    authenticate_or_request_with_http_basic('Railsbook') do |n, p|
      n == name &&
        Digest::SHA1.hexdigest(p) == passwd
    end
  end
end
