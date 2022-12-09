class ExchangeRate < ActiveRecord::Base
  scope :rate_close_to, -> (before = Date.today, limit = 1) do
    before ||= Date.today
    where('rate_date <= ?', before).order('rate_date DESC').limit(limit)
  end

  PRECISION = 12
  SCALE = 6

  def self.available_rates
    [:nok, :eur, :usd, :jpy, :bgn, :czk, :dkk, :gbp, :huf,
     :pln, :ron, :sek, :chf, :hrk, :rub, :try, :aud, :brl,
     :cad, :cny, :hkd, :idr, :ils, :inr, :krw, :mxn, :myr,
     :nzd, :php, :sgd, :thb, :zar, :isk, :aed, :afn, :all,
     :amd, :ang, :aoa, :ars, :awg, :azn, :bam, :bbd, :bdt,
     :bhd, :bif, :bmd, :bnd, :tnd, :bob, :bsd, :btn, :bwp,
     :byn, :bzd, :uah, :cdf, :clp, :clf, :cnh, :cop, :crc,
     :cuc, :cup, :cve, :djf, :dop, :dzd, :egp, :ern, :etb,
     :fjd, :fkp, :gel, :ggp, :ghs, :gip, :gmd, :gnf, :gtq,
     :gyd, :hnl, :htg, :imp, :iqd, :irr, :jep, :jmd, :jod,
     :kes, :kgs, :khr, :kmf, :kpw, :kwd, :kyd, :kzt, :lak,
     :lbp, :lkr, :lrd, :lsl, :lyd, :mad, :mdl, :mga, :mkd,
     :mmk, :mnt, :mop, :mro, :mur, :mvr, :mwk, :mzn, :nad,
     :ngn, :nio, :npr, :omr, :pab, :pen, :pgk, :pkr, :pyg,
     :qar, :rsd, :rwf, :sar, :sbd, :scr, :sdg, :shp, :sll,
     :sos, :srd, :ssp, :std, :svc, :syp, :szl, :tjs, :tmt,
     :top, :ttd, :twd, :tzs, :ugx, :uyu, :uzs, :vef, :vnd,
     :vuv, :wst, :xaf, :xag, :xau, :xcd, :xdr, :xof, :xpd,
     :xpf, :xpt, :yer, :zmw, :zwl]
    # No exchange rates or discontinued rates:
    # :byr  Belarusian ruble, now uses BYN
    # :eek  Estonian kroon, now uses EUR
    # :gbx  Pence Sterling
    # :ltl  Lithuanian litas, now uses EUR
    # :lvl  Latvian lats, now uses EUR
    # :mtl  Maltese lira, now uses EUR
    # :skk  Slovak koruna, now uses EUR
    # :tmm  Turkmenistan manat, now uses TMT
    # :xba  Bond Markets Unit European Composite Unit
    # :xbb  European Monetary Unit
    # :xbc  Bitcoin Plus
    # :xbd  Bond Markets Unit European Unit of Account
    # :xfu  UIC franc
    # :xts  Code reserved for testing purposes
    # :zmk, :zwd, :zwn, :zwr  Zimbabwean dollar, discontinued, now uses :zmw
  end

  def self.available_rates_params
    available_rates
        .map(&:to_s)
        .join(',')
  end

  def nok
    1.0
  end

  def rate(string)
    return nil if string.nil?
    method = string.downcase.to_s
    return nil unless self.respond_to?(method.to_sym)
    send(method)
  end

  def nok_to_eur(nok_value)
    nok_value / eur
  end

  def eur_to_nok(eur_value)
    eur_value * eur
  end
end
