defmodule ExmlTranslatorTest do
  use ExUnit.Case
  doctest ExmlTranslator

  def sample_xml do
    """
    <?xml version="1.0" encoding="utf-8"?>
    <!--
    http://23hodyny.com/yandex_market.xml?html_description=0&hash_tag=915553a6cfd3e4541fffcbc90a638445&yandex_cpa=&group_ids=&exclude_fields=&sales_notes=&product_ids=
     -->
    <!-- <!DOCTYPE yml_catalog SYSTEM "shops.dtd"> -->
    <yml_catalog date="2017-04-11 21:43">
    <offer available="true" id="398204756">
      <url>http://23hodyny.com/p398204756-sportivnij-godinnik-casio.html</url>
      <price>110</price>
      <currencyId>USD</currencyId>
      <categoryId>15988421</categoryId>
      <picture>https://images.ua.prom.st/562822150_w640_h640_ipathb11011545__6_500x500.jpeg</picture>
      <pickup>false</pickup>
      <delivery>true</delivery>
      <name>Спортивний годинник Casio G-Shock GLS-8900CM-4</name>
      <vendor>G-Shock</vendor>
      <country_of_origin>Япония</country_of_origin>
      <description>Спортивний годинник Casio G-Shock GLS-8900CM-4 Стійкий до  низьких температур Casio G-Shock GLS-8900CM-4 з серіїї Winter G-Lide призначений для використання у  зимових видах спорту. </description>
      <param name="Condition">New</param>
      <param name="Высота" unit="мм">55.1</param>
      <param name="Толщина" unit="мм">16.3</param>
      <param name="Дополнительные функции">Функция повтора сигнала будильника (snooze)|Включение/выключение звука кнопок|Будильник|Подсветка дисплея</param>
    </offer>
    </yml_catalog>
    """
  end


  test "the truth" do
    
  end
end
