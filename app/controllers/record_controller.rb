class RecordController < ApplicationController
  def find_by
    @book = Book.find_by(publish: '技術評論社')
    render 'books/show'
  end

  def find_by2
    @book = Book.find_by(publish: '技術評論社', price: 2919)
    render 'books/show'
  end

  def where
    @books = Book.where(publish: '技術評論社')
    render 'hello/list'
  end

  def ph1
    @books = Book.where('publish = ? AND price >= ?', params[:publish], params[:price])
    render 'hello/list'
  end

  def not
    @books = Book.where.not(isbn: params[:id])
    render 'books/index'
  end

  def order
    @books = Book.where(publish: '技術評論社').order(published: :asc)
    render 'hello/list'
  end

  #def select
  #  @books = Book.where('price >= 2000').select(:title, :price)
  #  render 'hello/list'
  #end
  
  def select2
    @pubs = Book.select(:publish).distinct.order(:publish)
  end

  def groupby
    @books = Book.select('publish, AVG(price) AS avg_price').group(:publish)
  end

  def havingby
    @books = Book.select('publish, AVG(price) AS avg_price').group(:publish).having('AVG(price) >= ?', 2500)
    render 'record/groupby'
  end

  def update_all
    cnt = Book.where(publish: 'Gihyo').update_all(publish: '技術評論社')
    render text: "#{cnt}件のデータを更新しました。"
  end

  # 空のオブジェクトにupdateするとinsertされる
  #def update
  #  cnt = Book.new.update(published: '2014-05-07')
  #  render text: "#{cnt}件のデータを更新しました。"
  #end
  
  def transact
    Book.transaction do
      b1 = Book.new({isbn: '978-4-7741-4223-0',
                    title: 'Rubyポケットリファレンス',
                    price: 2000, publish: '技術評論社', published: '2011-01-01'})
      b1.save!
      # raise '例外発生：処理はキャンセルされたよ'
      b2 = Book.new({isbn: '978-4-7741-4223-2',
                    title: 'Tomcatポケットリファレンス',
                    price: 2500, publish: '技術評論社', published: '2011-01-01'})
      b2.save!
    end
    render text: 'トランザクション成功！'
   rescue => e
      render text: e.message
  end

  def keywd
    @search = SearchKeyword.new
  end

  def keywd_process
    @search = SearchKeyword.new(params[:search_keyword])
    if @search.valid?
      render text: @search.keyword
    else
      render text: @search.errors.full_messages[0]
    end
  end

  def belongs
    @review = Review.find(3)
  end

  def hasmany
    @book = Book.find_by(isbn: '978-4-7741-5878-5')
  end

  def has_and_belongs
    @book = Book.find_by(isbn: '978-4-7741-5611-8')
  end

  def has_many_through
    @user = User.find_by(username: 'isatou')
  end

  def cache_counter
    @user = User.find(1)
    render text: @user.reviews.size
  end

  def memorize
    @book = Book.find(1)
    @memo = @book.memos.build({ body: '後で買う' })
    if @memo.save
      render text: 'メモを作成したよ'
    else
      render text: @memo.errors.full_messages[0]
    end
  end

  def assoc_join
    @books = Book.joins(:reviews, :authors).order('books.title, reviews.updated_at').select('books.*, reviews.body, authors.name')
  end

  def assoc_includes
    @books = Book.includes(:authors).all
  end
end
