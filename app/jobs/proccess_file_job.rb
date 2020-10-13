class ProccessFileJob < ApplicationJob
  queue_as :default

  def perform(params, user)
    @data = params[:doc]
    @headers = params[:no_model_fields].permit(params[:no_model_fields].keys).to_h
    @headers = @headers.sort_by{|k,v| v}
    @headers = [@headers[0][0], @headers[1][0], @headers[2][0], @headers[3][0], @headers[4][0], @headers[5][0]]
    rows = []
    @errors = []
    count = 1
    CSV.foreach(data[:doc].path, headers: @headers, col_sep: ';') do |row|
      if count != 1
        validate(row.to_hash)
        errors
        rows << row.to_hash
        if !error.empty?
          @errors << error + " Linea " + count.to_s
        end
      end
      count = count + 1
    end
    if @errors.empty?
      rows.each do |row|
        row['franchise'] = card_validate(row['credit_card'])
        row['last_four'] = row['credit_card'].split().last(4).join
        reg = user.contacts.new(row)
        reg.save
      end
  end

  private
  def validates(row)
    if row['name'].blank?
      @errors << 'El nombre no puede estar vacio'
    end
    if !/^[a-zA-Z0-9]+([- ][a-zA-Z0-9]+)*$/.match(row['name'])
      @errors << 'El nombre no cumple con el formato requerido'
    end
    if !row['dob'].match(/\d{4}-\d{2}-\d{2}/)
      @errors << 'El formato de la fecha no es valido'
    end
    if !row['telephone'].match(/\+\d{2}[- ]\d{3}[- ]\d{3}[- ]\d{2}[- ]\d{2}/)
      @errors << 'El formato de telefono no es valido'
    end
    if !/^[^@]+@[^@]+\.[a-zA-Z]{2,}$/.match(row['email'])
      @errors << 'El formato de email no es valido'
    end
    card = card_validate row['credit_card']
    if card == 'false'
      @errors << 'La tarjeta no corresponde con ninguna de las franquicias validas'
    end
    
  end

  def card_validate(card)
    card = card.to_s
    if (card[0..1] == '34' || card[0..1] == '37') && card.delete(' ').length ==15
      return 'American Express'
    elsif ('3528'..'3589').to_a.include?(card[0..3]) && (card.delete(' ').length >= 16 && card.delete(' ').length <= 19)
      return 'JCB'
    elsif (('2221'..'2720').include?(card[0..3]) || ('51'..'55').include?(card[0..1])) && card.delete(' ').length == 16
      return 'Mastercard'
    elsif card[0] == '4' && card.delete(' ').length == 16
      return 'Visa'
    elsif (card.length >= 14 && card.delete(' ').length <= 19)
      return 'Diners'
    else
      return 'false'
    end
  end

  def errors
    @errors.join('. ')
  end

end
