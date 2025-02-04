-- Element NFT trades (re-usable macro for all chains)
{% macro element_v1_base_trades(blockchain, erc721_sell_order_filled, erc721_buy_order_filled, erc1155_sell_order_filled, erc1155_buy_order_filled) %}


SELECT
  '{{blockchain}}' as blockchain,
  'element' as project,
  'v1' as project_version,
  evt_block_time AS block_time,
  cast(date_trunc('day', evt_block_time) as date) as block_date,
  cast(date_trunc('month', evt_block_time) as date) as block_month,
  evt_block_number AS block_number,
  'Buy' AS trade_category,
  'secondary' AS trade_type,
  erc721Token AS nft_contract_address,
  cast(erc721TokenId as uint256) AS nft_token_id,
  uint256 '1' AS nft_amount,
  taker AS buyer,
  maker AS seller,
  cast(erc20TokenAmount AS UINT256) AS price_raw,
  CASE
    WHEN erc20Token = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee THEN 0x0000000000000000000000000000000000000000
    ELSE erc20Token
  END AS currency_contract,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(fees[1], '"', 4) AS VARBINARY)
        ELSE NULL 
  END AS platform_fee_address,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(split_part(fees[1], '"amount":', 2), '}', 1) AS UINT256)
        ELSE 0
  END AS platform_fee_amount_raw,
  CAST(0 AS UINT256) AS royalty_fee_amount_raw,
  cast('0' AS VARBINARY) AS royalty_fee_address,
  contract_address AS project_contract_address,
  evt_tx_hash AS tx_hash,
  evt_index AS sub_tx_trade_id
FROM {{ erc721_sell_order_filled }}
{% if is_incremental() %}
WHERE {{incremental_predicate('evt_block_time')}}
{% endif %}

UNION ALL

SELECT
  '{{blockchain}}' as blockchain,
  'element' as project,
  'v1' as project_version,
  evt_block_time AS block_time,
  cast(date_trunc('day', evt_block_time) as date) as block_date,
  cast(date_trunc('month', evt_block_time) as date) as block_month,
  evt_block_number AS block_number,
  'Sell' AS trade_category,
  'secondary' AS trade_type,
  erc721Token AS nft_contract_address,
  cast(erc721TokenId as uint256) AS nft_token_id,
  uint256 '1' AS nft_amount,
  maker AS buyer,
  taker AS seller,
  cast(erc20TokenAmount AS UINT256) AS price_raw,
  CASE
    WHEN erc20Token = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee THEN 0x0000000000000000000000000000000000000000
    ELSE erc20Token
  END AS currency_contract,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(fees[1], '"', 4) AS VARBINARY)
        ELSE NULL 
  END AS platform_fee_address,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(split_part(fees[1], '"amount":', 2), '}', 1) AS UINT256)
        ELSE 0
  END AS platform_fee_amount_raw,
  CAST(0 AS UINT256) AS royalty_fee_amount_raw,
  cast('0' AS VARBINARY) AS royalty_fee_address,
  contract_address AS project_contract_address,
  evt_tx_hash AS tx_hash,
  evt_index AS sub_tx_trade_id
FROM {{ erc721_buy_order_filled }}
{% if is_incremental() %}
WHERE {{incremental_predicate('evt_block_time')}}
{% endif %}

UNION ALL

SELECT
  '{{blockchain}}' as blockchain,
  'element' as project,
  'v1' as project_version,
  evt_block_time AS block_time,
  cast(date_trunc('day', evt_block_time) as date) as block_date,
  cast(date_trunc('month', evt_block_time) as date) as block_month,
  evt_block_number AS block_number,
  'Buy' AS trade_category,
  'secondary' AS trade_type,
  erc1155Token AS nft_contract_address,
  cast(erc1155TokenId as uint256) AS nft_token_id,
  uint256 '1' AS nft_amount,
  taker AS buyer,
  maker AS seller,
  cast(erc20FillAmount AS UINT256) AS price_raw,
  CASE
    WHEN erc20Token = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee THEN 0x0000000000000000000000000000000000000000
    ELSE erc20Token
  END AS currency_contract,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(fees[1], '"', 4) AS VARBINARY)
        ELSE NULL 
  END AS platform_fee_address,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(split_part(fees[1], '"amount":', 2), '}', 1) AS UINT256)
        ELSE 0
  END AS platform_fee_amount_raw,
  CAST(0 AS UINT256) AS royalty_fee_amount_raw,
  cast('0' AS VARBINARY) AS royalty_fee_address,
  contract_address AS project_contract_address,
  evt_tx_hash AS tx_hash,
  evt_index AS sub_tx_trade_id
FROM {{ erc1155_buy_order_filled }}
{% if is_incremental() %}
WHERE {{incremental_predicate('evt_block_time')}}
{% endif %}

UNION ALL

SELECT
  '{{blockchain}}' as blockchain,
  'element' as project,
  'v1' as project_version,
  evt_block_time AS block_time,
  cast(date_trunc('day', evt_block_time) as date) as block_date,
  cast(date_trunc('month', evt_block_time) as date) as block_month,
  evt_block_number AS block_number,
  'Buy' AS trade_category,
  'secondary' AS trade_type,
  erc1155Token AS nft_contract_address,
  cast(erc1155TokenId as uint256) AS nft_token_id,
  uint256 '1' AS nft_amount,
  maker AS buyer,
  taker AS seller,
  cast(erc20FillAmount AS UINT256) AS price_raw,
  CASE
    WHEN erc20Token = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee THEN 0x0000000000000000000000000000000000000000
    ELSE erc20Token
  END AS currency_contract,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(fees[1], '"', 4) AS VARBINARY)
        ELSE NULL 
  END AS platform_fee_address,
  CASE WHEN cardinality(fees) > 0 THEN CAST(split_part(split_part(fees[1], '"amount":', 2), '}', 1) AS UINT256)
        ELSE 0
  END AS platform_fee_amount_raw,
  CAST(0 AS UINT256) AS royalty_fee_amount_raw,
  cast('0' AS VARBINARY) AS royalty_fee_address,
  contract_address AS project_contract_address,
  evt_tx_hash AS tx_hash,
  evt_index AS sub_tx_trade_id
FROM {{ erc1155_sell_order_filled }}
{% if is_incremental() %}
WHERE {{incremental_predicate('evt_block_time')}}
{% endif %}

{% endmacro %}
