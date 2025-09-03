// XSS対策用のエスケープ関数
const esc = (s) => String(s).replace(/[&<>"']/g, c => ({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;', "'":'&#39;'}[c]));

// フィールドヘルパーと入力タイプの切り替え
function toggleFieldHelper(selectElement) {
    const conditionDiv = selectElement.closest('.condition-item');
    const rejectionHelper = conditionDiv.querySelector('.rejection-code-helper');
    const typeHelper = conditionDiv.querySelector('.trademark-type-helper');
    const conditionId = selectElement.id.split('_')[1];
    const inputWrapper = document.getElementById(`input_wrapper_${conditionId}`);
    
    // すべてのヘルパーを非表示
    if (rejectionHelper) rejectionHelper.style.display = 'none';
    if (typeHelper) typeHelper.style.display = 'none';
    
    // 日付フィールドの場合は日付範囲入力に変更
    if (selectElement.value === 'app_date' || selectElement.value === 'reg_date' || selectElement.value === 'pub_date') {
        inputWrapper.innerHTML = `
            <input type="date" id="start_date_${conditionId}" style="padding: 5px;">
            <span> 〜 </span>
            <input type="date" id="end_date_${conditionId}" style="padding: 5px;">
        `;
    } else {
        // 通常のテキスト入力に戻す
        inputWrapper.innerHTML = `<input type="text" id="keyword_${conditionId}" placeholder="キーワード" style="width: 250px;">`;
        
        // 選択されたタイプに応じてヘルパーを表示
        if (selectElement.value === 'rejection_reason') {
            if (rejectionHelper) {
                rejectionHelper.style.display = 'block';
            }
        } else if (selectElement.value === 'trademark_type') {
            if (typeHelper) {
                typeHelper.style.display = 'block';
            }
        }
    }
}

// 条件のカウンター
let conditionCount = 0;

// 現在の検索結果を保持
let currentSearchResults = null;
let originalSearchResults = null;  // ソート前のオリジナルデータを保持

// 検索タイプのオプション
const searchTypes = [
    {value: 'trademark', label: '商標名'},
    {value: 'phonetic', label: '称呼（発音同一）'},
    {value: 'phonetic_exact', label: '称呼（表記同一）'},
    {value: 'trademark_type', label: '商標タイプ'},
    {value: 'app_num', label: '出願番号'},
    {value: 'reg_num', label: '登録番号'},
    {value: 'intl_reg_num', label: '国際登録番号'},
    {value: 'class', label: '区分'},
    {value: 'applicant', label: '出願人'},
    {value: 'similar_group', label: '類似群コード'},
    {value: 'goods_services', label: '商品・役務'},
    {value: 'rejection_reason', label: '拒絶条文コード'},
    {value: 'vienna_code', label: 'ウィーンコード'},
    {value: 'app_date', label: '出願日'},
    {value: 'reg_date', label: '登録日'},
    {value: 'pub_date', label: '公開日'}
];

// 条件を追加する関数
function addCondition() {
    conditionCount++;
    const container = document.getElementById('searchConditions');
    const condDiv = document.createElement('div');
    condDiv.id = `condition_${conditionCount}`;
    condDiv.className = 'condition-item';
    
    let optionsHtml = searchTypes.map(t => 
        `<option value="${t.value}">${t.label}</option>`
    ).join('');
    
    // 条件が2つ以上になったら演算子セレクタを表示
    const conditionElements = container.getElementsByClassName('condition-item');
    if (conditionElements.length >= 1) {
        document.getElementById('operatorSection').style.display = 'block';
    }
    
    condDiv.innerHTML = `
        <label>条件${conditionCount}:
            <select id="type_${conditionCount}" onchange="toggleFieldHelper(this)">
                ${optionsHtml}
            </select>
            <span id="input_wrapper_${conditionCount}">
                <input type="text" id="keyword_${conditionCount}" placeholder="キーワード" style="width: 250px;">
            </span>
            <button type="button" onclick="removeCondition(${conditionCount})" style="background: #dc3545; color: white; padding: 3px 8px; margin-left: 10px;">削除</button>
        </label>
        <div class="trademark-type-helper" style="display:none;">
            <strong>商標タイプの指定方法:</strong><br>
            • <code>通常</code> - 通常商標<br>
            • <code>標準文字</code> - 標準文字商標<br>
            • <code>立体商標</code> - 立体商標<br>
            • <code>音商標</code> - 音商標<br>
            • <code>動き商標</code> - 動き商標<br>
            • <code>ホログラム商標</code> - ホログラム商標<br>
            • <code>色彩のみからなる商標</code> - 色彩商標<br>
            • <code>位置商標</code> - 位置商標<br>
            • <code>その他の商標</code> - その他<br>
            • <code>?</code> - 全タイプ<br>
        </div>
        <div class="rejection-code-helper" style="display:none;">
            <strong>拒絶条文コード入力例:</strong><br>
            • 完全一致: 30, 41, 42<br>
            • 前方一致: 3? (3で始まる全て), 4? (4で始まる全て)<br>
            • 複数指定: 30 40 (スペース区切り) または 30,40 (カンマ区切り)<br>
            • 全指定: ??<br>
            <details style="margin-top:5px;">
                <summary style="cursor:pointer; color:#0066cc;">拒絶条文コード完全一覧（特許庁公式）</summary>
                <div style="margin-top:5px; font-size:12px; max-height:300px; overflow-y:auto;">
                    <strong>【第3条関連（登録要件）】</strong><br>
                    30: 第３条１項各号<br>
                    31: 第３条１項各号＋第４条１項１６号<br>
                    32: 第３条１項柱書<br>
                    33: 第３条１項柱書（定型文付）<br>
                    34: 第３条１項柱書（定型文、但し書付）<br>
                    <br>
                    <strong>【第4条関連（不登録事由）】</strong><br>
                    40: 第４条１項各号（第１１号～第１３号除く）<br>
                    41: 第４条１項１１号<br>
                    42: 第４条１項１２号<br>
                    43: 第４条１項１３号<br>
                    44: 第４条１項１１号（番号列記）<br>
                    45: 第８条１項＋第４条１項１１号<br>
                    46: 第４条１項１６号<br>
                    47: 第１９条２項（公益的不登録理由、不使用）<br>
                    48: 更新（住所相違）<br>
                    49: 更新（氏名相違）<br>
                    <br>
                    <strong>【第3条・第4条組み合わせ】</strong><br>
                    52: 第３条柱書＋第４条１項１１号<br>
                    53: 第３条各号＋第４条１項１１号<br>
                    54: 第４条各号＋第４条１項１１号<br>
                    55: その他＋第４条１項１１号<br>
                    <br>
                    <strong>【第6条関連（一商標一出願・区分）】</strong><br>
                    60: 条文なし<br>
                    61: 第６条１項<br>
                    62: 第６条１項（防護）又は第６条２項（防護）<br>
                    63: 第６条１項＋第６条２項<br>
                    64: 第６４条（防護）<br>
                    65: 第６条１項（防護）＋第６条２項（防護）<br>
                    66: 第６条１項又は第６条２項<br>
                    67: 第６条１項（防護）<br>
                    68: 防護更新<br>
                    69: 第６条２項<br>
                    <br>
                    <strong>【第7条関連（団体商標）】</strong><br>
                    71: 第７条１項（商標・商品類似）<br>
                    72: 第７条１項（番号列記）<br>
                    73: 第７条３項（商標非類似）<br>
                    74: 第７条の２第１項<br>
                    75: 第７条３項（商品非類似）<br>
                    76: 第７条３項（商標・商品非類似）<br>
                    <br>
                    <strong>【附則関連（書換）】</strong><br>
                    77: 附則第４条１項（指定商品の拡大）<br>
                    78: 附則第４条１項（書換区分相違）<br>
                    79: 附則第６条２項（氏名・名称相違）<br>
                    80: 附則第６条２項（住所相違）<br>
                    81: 附則第６条２項（氏名及び住所相違）<br>
                    <br>
                    <strong>【第8条との組み合わせ】</strong><br>
                    82: 第３条柱書＋第８条１項＋第４条１項１１号<br>
                    83: 第３条各号＋第８条１項＋第４条１項１１号<br>
                    84: 第４条各号＋第８条１項＋第４条１項１１号<br>
                    85: その他＋第８条１項＋第４条１項１１号<br>
                    <br>
                    <strong>【その他の組み合わせ】</strong><br>
                    92: 第３条柱書＋その他（第４条１項１１号を除く）<br>
                    93: 第３条各号＋その他（第４条１項１１号を除く）<br>
                </div>
            </details>
        </div>
    `;
    
    container.appendChild(condDiv);
}

// 条件を削除する関数
function removeCondition(id) {
    const elem = document.getElementById(`condition_${id}`);
    if (elem) {
        elem.remove();
    }
    
    // 条件が1つ以下になったら演算子セレクタを隠す
    const container = document.getElementById('searchConditions');
    const conditionElements = container.getElementsByClassName('condition-item');
    if (conditionElements.length <= 1) {
        document.getElementById('operatorSection').style.display = 'none';
    }
}

// 初期状態で3つの条件を追加（商標名、称呼、区分）
window.addEventListener('DOMContentLoaded', () => {
    // 1つ目：商標名
    addCondition();
    const cond1 = document.querySelector('#condition_1 select');
    if (cond1) cond1.value = 'trademark';
    
    // 2つ目：称呼（表記同一）
    addCondition();
    const cond2 = document.querySelector('#condition_2 select');
    if (cond2) cond2.value = 'phonetic_exact';
    
    // 3つ目：区分
    addCondition();
    const cond3 = document.querySelector('#condition_3 select');
    if (cond3) cond3.value = 'class';
    
    // 検索フォームの処理
    document.getElementById('complexSearchForm').onsubmit = async (e) => {
        e.preventDefault();
        const resultsDiv = document.getElementById('results');
        resultsDiv.textContent = '検索中...';
        
        // すべての条件を収集
        const conditions = [];
        const conditionDivs = document.querySelectorAll('[id^="condition_"]');
        
        conditionDivs.forEach(div => {
            const id = div.id.split('_')[1];
            const type = document.getElementById(`type_${id}`)?.value;
            
            if (!type) return;
            
            // Check if this is a date type field
            if (type === 'app_date' || type === 'reg_date' || type === 'pub_date') {
                const startDate = document.getElementById(`start_date_${id}`)?.value;
                const endDate = document.getElementById(`end_date_${id}`)?.value;
                
                if (startDate || endDate) {
                    // Format dates as YYYYMMDD for backend
                    const formatDate = (dateStr) => {
                        if (!dateStr) return '';
                        return dateStr.replace(/-/g, '');
                    };
                    
                    conditions.push({
                        type: 'date_range',
                        keyword: `${type}:${formatDate(startDate)}:${formatDate(endDate)}`
                    });
                }
            } else {
                let keyword = document.getElementById(`keyword_${id}`)?.value;
                
                if (type && keyword) {
                    // 国際登録番号の場合は非数字文字を削除
                    if (type === 'intl_reg_num') {
                          // 数字・*・? だけ許可（全角混入などはここで弾く）
                        keyword = (keyword || '').trim().replace(/[^\d*?]/g, '');
                    }
                    conditions.push({
                        type: type,
                        keyword: keyword
                    });
                }
            }
        });
        
        const operator = document.getElementById('globalOperator').value;
        
        console.log('送信条件:', conditions, 'operator:', operator);  // デバッグ
        
        if (conditions.length === 0) {
            resultsDiv.textContent = '少なくとも1つの条件を入力してください';
            return;
        }
        
        try {
            const response = await fetch('/search_complex', {
                method: 'POST',
                headers: {'Content-Type': 'application/json'},
                body: JSON.stringify({
                    conditions: conditions,
                    operator: operator,
                    sort_by: 'app_date_desc'  // デフォルトのソート
                })
            });
            
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            
            const data = await response.json();
            console.log('[DEBUG] API response:', data);  // デバッグ詳細
            console.log('[DEBUG] Number of results:', data.results ? data.results.length : 0);  // デバッグ
            displayResults(data);
        } catch (error) {
            console.error('複合検索エラー:', error);
            resultsDiv.textContent = 'エラー: ' + error.message;
        }
    };
});

// ========== リファクタリング用共通関数 ==========

// 単一フィールドの表示（空値は表示しない）
function addField(label, value) {
    // 空値のパターンをチェック
    if (!value || value === '' || value === 'N/A' || 
        value === '0000000' || value === '00000000' || value === '000') {
        return '';
    }
    return `<div class="field"><span class="field-label">${label}:</span> ${esc(value)}</div>`;
}

// 配列フィールドの表示（空配列は表示しない）
function addArrayField(label, arr) {
    if (!arr || !Array.isArray(arr) || arr.length === 0) {
        return '';
    }
    // 空文字列を除外
    const filtered = arr.filter(item => item && String(item).trim());
    if (filtered.length === 0) {
        return '';
    }
    return `<div class="field"><span class="field-label">${label}:</span> ${filtered.map(item => esc(item)).join(', ')}</div>`;
}

// 日付フォーマット（YYYYMMDD → YYYY/MM/DD）
function formatDate(dateStr) {
    if (!dateStr || dateStr === '00000000' || dateStr.length !== 8) {
        return '';  // 空文字列を返して表示しない
    }
    return `${dateStr.slice(0,4)}/${dateStr.slice(4,6)}/${dateStr.slice(6,8)}`;
}

function displayResults(data) {
    const resultsDiv = document.getElementById('results');
    
    console.log('[DEBUG] displayResults called with:', data);  // デバッグ
    console.log('[DEBUG] data.results:', data.results);  // デバッグ
    console.log('[DEBUG] data.results length:', data.results ? data.results.length : 'undefined');  // デバッグ
    
    if (data.error) {
        resultsDiv.innerHTML = `<div style="color: red">エラー: ${esc(data.error)}</div>`;
        return;
    }
    
    if (!data.results || data.results.length === 0) {
        resultsDiv.innerHTML = '<div>検索結果がありません。</div>';
        return;
    }
    
    // 検索結果を保持
    currentSearchResults = data;
    originalSearchResults = JSON.parse(JSON.stringify(data));  // ディープコピーでオリジナルを保存
    
    let html = `<h2>検索結果: ${esc(data.results.length)}件</h2>`;
    
    // 並び替えセレクタを追加
    html += `
        <div style="margin: 10px 0;">
            <label>並び替え: 
                <select id="sortSelector" onchange="sortResults()">
                    <option value="app_date_desc">出願日（新しい順）</option>
                    <option value="app_date_asc">出願日（古い順）</option>
                    <option value="reg_date_desc">登録日（新しい順）</option>
                    <option value="reg_date_asc">登録日（古い順）</option>
                    <option value="trademark_asc">商標名（A-Z）</option>
                    <option value="trademark_desc">商標名（Z-A）</option>
                </select>
            </label>
        </div>
    `;
    
    // 複合検索の場合、検索条件を表示
    if (data.search_type === 'complex') {
        html += '<div style="margin: 10px 0; padding: 15px; background: #e8f4f8; border-left: 4px solid #17a2b8; border-radius: 4px;">';
        html += '<strong>検索条件:</strong><br>';
        if (data.conditions && data.conditions.length > 0) {
            const typeLabels = {
                'trademark': '商標名',
                'phonetic': '称呼（発音同一）',
                'phonetic_exact': '称呼（表記同一）',
                'app_num': '出願番号',
                'reg_num': '登録番号',
                'intl_reg_num': '国際登録番号',
                'class': '区分',
                'applicant': '出願人',
                'similar_group': '類似群コード',
                'goods_services': '商品・役務',
                'rejection_reason': '拒絶条文コード',
                'date_range': '日付範囲',
                'app_date': '出願日',
                'reg_date': '登録日',
                'pub_date': '公開日'
            };
            const conditionsText = data.conditions.map(c => 
                `${typeLabels[c.type] || c.type}「${esc(c.keyword)}」`
            ).join(` ${data.operator || 'AND'} `);
            html += conditionsText;
        }
        html += '</div>';
    }
    
    data.results.forEach((result, index) => {
        const info = result.basic_info || result;
        
        // 拒絶条文コード検索の結果かどうかを判定
        // search_specificに拒絶条文コード情報があるかチェック
        const isRejectionSearch = result.search_specific && result.search_specific.rejection_reason_code !== undefined;
        
        // デバッグ用（国際登録番号検索の場合）
        if (result.search_specific && result.search_specific.search_type === 'intl_reg_num') {
            console.log('[DEBUG] International registration search detected, displaying full info');
        }
        
        // 商標名または商標画像を表示
        let trademarkDisplay = '';
        if (info.trademark_name === '[商標画像]' && info.trademark_image_data) {
            // Base64エンコードされた画像を表示
            // Base64データをエスケープ（不正なスクリプト挿入を防ぐ）
            const safeImageData = String(info.trademark_image_data).replace(/[^A-Za-z0-9+/=]/g, '');
            trademarkDisplay = `<img src="data:image/jpeg;base64,${safeImageData}" alt="商標画像" style="max-width: 200px; max-height: 200px; display: block; margin: 10px 0;">`;
        } else {
            trademarkDisplay = esc(info.trademark_name || 'N/A');
        }
        
        // マドプロ案件の判定（出願番号の5-6桁目が35,36,37）
        let isMadrid = false;
        const appNum = info.app_num || '';
        if (appNum.length >= 6) {
            const position5_6 = appNum.substring(4, 6);
            isMadrid = ['35', '36', '37'].includes(position5_6);
        }
        
        // 出願番号をハイフン付きに変換
        const formatAppNumForJPlatPat = (appNum) => {
            if (!appNum) return '';
            const numStr = appNum.toString();
            if (numStr.length >= 8) {
                return numStr.substring(0, 4) + '-' + numStr.substring(4);
            }
            return numStr;
        };
        
        // J-PlatPatボタンのHTML（マドプロの場合は国際登録番号と出願日を渡す）
        // マドプロの場合、出願日を国際登録日として使用
        const madridDate = isMadrid ? (info.app_date || '') : '';
        const jplatpatButton = info.app_num ? `
            <button onclick="openJPlatPat('${esc(info.app_num)}', '${esc(info.intl_reg_num || '')}', '${esc(madridDate)}')" 
                    title="J-PlatPatで${isMadrid && info.intl_reg_num ? '国際登録番号 ' + esc(info.intl_reg_num) : '出願番号 ' + esc(formatAppNumForJPlatPat(info.app_num))}を検索"
                    style="margin-left: 10px; background: #0066cc; color: white; padding: 3px 10px; border: none; border-radius: 3px; cursor: pointer;">
                J-PlatPat
            </button>` : '';
        
        html += `
            <div class="result">
                <h3>[${index + 1}] ${trademarkDisplay}</h3>
                ${!isMadrid ? `<div class="field"><span class="field-label">出願番号:</span> ${esc(info.app_num)}${jplatpatButton}</div>` : `<div class="field"><span class="field-label">マドプロ管理番号:</span> ${esc(info.app_num)}</div>`}
                ${isMadrid && info.intl_reg_num ? `<div class="field"><span class="field-label">国際登録番号:</span> ${esc(info.intl_reg_num)}${jplatpatButton}</div>` : ''}
                ${addField('登録番号', info.reg_num)}
                ${addField('出願日', formatDate(info.app_date))}
                ${addField('登録日', formatDate(info.reg_date))}
        `;
        
        // 拒絶条文コード検索の場合は特別な表示
        if (isRejectionSearch) {
            const rejectionInfo = result.search_specific || {};
            // 日本語の条文名があればそれを表示、なければコードを表示
            const rejectionDisplay = rejectionInfo.rejection_reason_article || 
                                   (rejectionInfo.rejection_reason_code ? `コード${rejectionInfo.rejection_reason_code}` : '');
            html += addField('拒絶理由', rejectionDisplay);
        }
        
        // 通常の検索結果の場合（拒絶条文検索以外はすべて表示）
        if (!isRejectionSearch) {
            // デバッグ: データの存在を確認
            console.log('[DEBUG] Display info for app_num:', info.app_num);
            console.log('  - classes:', info.classes);
            console.log('  - phonetics:', info.phonetics);
            console.log('  - applicants:', info.applicants);
            console.log('  - isMadrid:', isMadrid);
            
            // 区分の表示を削除（商品・役務の項目で表示されるため）
            // html += addArrayField('区分', info.classes);
            html += addArrayField('称呼', info.phonetics);
            html += addArrayField('出願人', info.applicants);
            html += addArrayField('代理人', info.agents);
            html += addArrayField('権利者', info.right_holders);
        }
        
        // ステータス情報
        html += addField('最終処分コード', info.final_disposition_type);
        html += addField('最終処分記事', info.final_disposition_article);
        html += addField('最終処分日', formatDate(info.final_disposition_date));
        
        // 公報情報
        html += addField('登録公報発行日', formatDate(info.reg_article_gazette_date));
        html += addField('公開公報発行日', formatDate(info.pub_article_gazette_date));
        
        // 存続期間・分納情報
        html += addField('存続期間満了日', formatDate(info.conti_prd_expire_date));
        html += addField('次回分納期限日', formatDate(info.next_pen_payment_limit_date));
        
        // マドプロ特有の情報
        if (isMadrid) {
            html += addField('国際登録日', formatDate(info.intl_reg_date));
            html += addField('事後指定日', formatDate(info.after_designation_date));
            html += addField('マドプロ登録日', formatDate(info.madrid_reg_date));
            html += addField('マドプロ公開日', formatDate(info.madrid_public_date));
            html += addField('名義人', info.madrid_holder_name);
            html += addField('名義人住所', info.madrid_holder_address);
            html += addField('基礎国コード', info.base_country_code);
            html += addField('基礎出願日', formatDate(info.base_app_date));
            html += addField('優先権主張日', formatDate(info.prior_app_right_occr_dt));
        }
        
        // 出願種別・付加情報
        const appTypes = [];
        if (info.app_type1) appTypes.push(info.app_type1);
        if (info.app_type2) appTypes.push(info.app_type2);
        if (info.app_type3) appTypes.push(info.app_type3);
        if (info.app_type4) appTypes.push(info.app_type4);
        if (info.app_type5) appTypes.push(info.app_type5);
        if (appTypes.length > 0) {
            html += `<div class="field"><span class="field-label">出願種別:</span> ${appTypes.map(t => esc(t)).join(', ')}</div>`;
        }
        if (info.article3_2_flag === '1') {
            html += addField('3条2項適用', 'あり');
        }
        if (info.article5_4_flag === '1') {
            html += addField('5条4項適用', 'あり');
        }
        
        // 審査・査定情報
        html += addField('審査種別', info.exam_type);
        html += addField('査定種別', info.decision_type);
        
        // 審判情報
        html += addArrayField('審判番号', info.appeal_nums);
        html += addArrayField('審判種別', info.appeal_types);
        
        // 出願人住所・国県コード
        html += addArrayField('出願人住所', info.applicant_addresses);
        html += addArrayField('国県コード', info.applicant_country_codes);
        
        // 商標タイプ
        html += addField('商標タイプ', info.trademark_type);
        
        // 詳細な説明
        if (info.detailed_description) {
            html += `<div class="field"><span class="field-label">詳細な説明:</span><br>`;
            html += `<div style="margin-left: 120px; white-space: pre-wrap;">${esc(info.detailed_description)}</div>`;
            html += `</div>`;
        }
        
        // ウィーンコード
        html += addArrayField('ウィーンコード', info.vienna_codes);
        
        // 拒絶条文コード
        html += addArrayField('拒絶条文', info.rejection_reason_codes);
        
        // 審決分類
        html += addArrayField('審決分類', info.appeal_disposition_codes);
        
        // 優先権情報
        if (info.priority_claims && info.priority_claims.length > 0) {
            html += `<div class="field"><span class="field-label">優先権主張:</span><br>`;
            info.priority_claims.forEach(claim => {
                const countryDisplay = claim.country_name || claim.country_code;
                html += `&nbsp;&nbsp;• ${esc(countryDisplay)} ${esc(claim.app_num)} (${esc(claim.date)})<br>`;
            });
            html += `</div>`;
        }
        
        // 異議申立情報
        if (info.oppositions && info.oppositions.length > 0) {
            html += `<div class="field"><span class="field-label">異議申立:</span><br>`;
            info.oppositions.forEach(opposition => {
                html += `&nbsp;&nbsp;• 異議番号: ${esc(opposition.opposition_num)} 申立日: ${esc(opposition.app_date)}`;
                if (opposition.disposition_code) {
                    html += ` 処分: ${esc(opposition.disposition_code)}`;
                }
                if (opposition.confirm_date && opposition.confirm_date !== '00000000') {
                    html += ` 確定日: ${esc(opposition.confirm_date)}`;
                }
                html += `<br>`;
            });
            html += `</div>`;
        }
        
        // 移転受付情報
        if (info.transfers && info.transfers.length > 0) {
            html += `<div class="field"><span class="field-label">移転受付:</span><br>`;
            info.transfers.forEach(transfer => {
                html += `&nbsp;&nbsp;• 管理番号: ${esc(transfer.mu_num)}`;
                if (transfer.receipt_info) {
                    html += ` ${esc(transfer.receipt_info)}`;
                }
                if (transfer.update_date && transfer.update_date !== '00000000') {
                    html += ` (更新日: ${esc(transfer.update_date)})`;
                }
                html += `<br>`;
            });
            html += `</div>`;
        }
        
        // 防護標章関連情報（000は無効値なので除外）
        const hasValidDefensiveInfo = (
            (info.defensive_num && info.defensive_num !== '000') ||
            info.defensive_orig_app_num || 
            info.defensive_orig_reg_num || 
            info.renewal_defensive_num || 
            info.rewrite_defensive_num
        );
        
        if (hasValidDefensiveInfo) {
            html += `<div class="field"><span class="field-label">防護標章関連:</span><br>`;
            if (info.defensive_num && info.defensive_num !== '000') {
                html += `&nbsp;&nbsp;• 防護標章番号: ${esc(info.defensive_num)}<br>`;
            }
            if (info.defensive_orig_app_num) {
                html += `&nbsp;&nbsp;• 元出願番号: ${esc(info.defensive_orig_app_num)}<br>`;
            }
            if (info.defensive_orig_reg_num) {
                html += `&nbsp;&nbsp;• 元登録番号: ${esc(info.defensive_orig_reg_num)}<br>`;
            }
            if (info.defensive_orig_split_num) {
                html += `&nbsp;&nbsp;• 元分割番号: ${esc(info.defensive_orig_split_num)}<br>`;
            }
            if (info.renewal_defensive_num) {
                html += `&nbsp;&nbsp;• 更新防護標章番号: ${esc(info.renewal_defensive_num)}<br>`;
            }
            if (info.rewrite_defensive_num) {
                html += `&nbsp;&nbsp;• 書換防護標章番号: ${esc(info.rewrite_defensive_num)}<br>`;
            }
            html += `</div>`;
        }
        
        // 中間記録を審査・審判・登録に分けて表示
        if (info.progress_records) {
            // バックエンドから分類済みのデータを受け取る
            const examRecords = info.progress_records.exam || [];
            const trialRecords = info.progress_records.trial || [];
            const registrationRecords = info.progress_records.registration || [];
            
            // 審査中間記録
            if (examRecords.length > 0) {
                html += `<div class="field"><span class="field-label">審査中間記録:</span></div>`;
                examRecords.forEach(record => {
                    const [code, date] = record.split(':');
                    html += `<div class="intermediate-records">• ${esc(code)} (${esc(date)})</div>`;
                });
            }
            
            // 審判中間記録
            if (trialRecords.length > 0) {
                html += `<div class="field"><span class="field-label">審判中間記録:</span></div>`;
                trialRecords.forEach(record => {
                    const [code, date] = record.split(':');
                    html += `<div class="intermediate-records">• ${esc(code)} (${esc(date)})</div>`;
                });
            }
            
            // 登録中間記録
            if (registrationRecords.length > 0) {
                html += `<div class="field"><span class="field-label">登録中間記録:</span></div>`;
                registrationRecords.forEach(record => {
                    const [code, date] = record.split(':');
                    html += `<div class="intermediate-records">• ${esc(code)} (${esc(date)})</div>`;
                });
            }
        }
        
        // 審判中間記録（trial_intermediate_recordsから）  
        if (info.trial_intermediate_records && info.trial_intermediate_records.length > 0) {
            html += `<div class="field"><span class="field-label">審判中間記録:</span></div>`;
            info.trial_intermediate_records.forEach(record => {
                const recordText = record['中間記録'] || record['中間コード'] || '';
                const date = record['日付'] || '';
                if (recordText || date) {
                    html += `<div class="intermediate-records">• ${esc(recordText)} (${esc(date)})</div>`;
                }
            });
        }
        
        // 登録中間記録（registration_intermediate_recordsから）
        if (info.registration_intermediate_records && info.registration_intermediate_records.length > 0) {
            html += `<div class="field"><span class="field-label">登録中間記録:</span></div>`;
            info.registration_intermediate_records.forEach(record => {
                const recordText = record['中間記録'] || record['中間コード'] || '';
                const date = record['日付'] || '';
                if (recordText || date) {
                    html += `<div class="intermediate-records">• ${esc(recordText)} (${esc(date)})</div>`;
                }
            });
        }
        
        // 旧フィールド（互換性のため残す）
        html += addField('最終処分コード', info.disposition_code);
        html += addField('最終処分日', formatDate(info.disposition_date));
        html += addField('ステータス', info.status);
        
        if (info.goods_services && Object.keys(info.goods_services).length > 0) {
            // 区分を数値として昇順ソート
            const sortedClasses = Object.keys(info.goods_services).sort((a, b) => parseInt(a) - parseInt(b));
            
            // 商品・役務を表示（日本語のみの場合は「商品・役務」として表示）
            let hasOnlyJapanese = true;
            
            // すべての項目が（日）で始まるかチェック
            for (const cls of sortedClasses) {
                const goods = info.goods_services[cls];
                if (!goods.startsWith('（日）')) {
                    hasOnlyJapanese = false;
                    break;
                }
            }
            
            if (hasOnlyJapanese) {
                // 日本語のみの場合
                html += '<div class="field"><span class="field-label">商品・役務:</span></div>';
                for (const cls of sortedClasses) {
                    const goods = info.goods_services[cls];
                    // （日）を削除して表示
                    const cleanGoods = goods.replace(/^（日）/, '');
                    html += `<div class="goods-services">第${esc(cls)}類: ${esc(cleanGoods)}</div>`;
                }
            } else {
                // 英語と日本語が混在している場合
                const englishGoods = {};
                const japaneseGoods = {};
                
                for (const cls of sortedClasses) {
                    const goods = info.goods_services[cls];
                    
                    if (goods.startsWith('（日）')) {
                        // 日本語データ
                        japaneseGoods[cls] = goods.substring(4);
                    } else if (goods.includes('、（日）')) {
                        // 英語と日本語が混在
                        const parts = goods.split('、');
                        const englishParts = [];
                        const japaneseParts = [];
                        
                        parts.forEach(part => {
                            if (part.startsWith('（日）')) {
                                japaneseParts.push(part.substring(4));
                            } else {
                                englishParts.push(part);
                            }
                        });
                        
                        if (englishParts.length > 0) {
                            englishGoods[cls] = englishParts.join('、');
                        }
                        if (japaneseParts.length > 0) {
                            japaneseGoods[cls] = japaneseParts.join('、');
                        }
                    } else {
                        // 英語データのみ
                        englishGoods[cls] = goods;
                    }
                }
                
                // 英語の商品・役務を表示
                if (Object.keys(englishGoods).length > 0) {
                    html += '<div class="field"><span class="field-label">商品・役務:</span></div>';
                    for (const cls of Object.keys(englishGoods).sort((a, b) => parseInt(a) - parseInt(b))) {
                        html += `<div class="goods-services">第${esc(cls)}類: ${esc(englishGoods[cls])}</div>`;
                    }
                }
                
                // 日本語の商品・役務を表示
                if (Object.keys(japaneseGoods).length > 0) {
                    html += '<div class="field"><span class="field-label">商品・役務（訳）:</span></div>';
                    for (const cls of Object.keys(japaneseGoods).sort((a, b) => parseInt(a) - parseInt(b))) {
                        html += `<div class="goods-services">第${esc(cls)}類: ${esc(japaneseGoods[cls])}</div>`;
                    }
                }
            }
        }
        
        if (info.similar_groups && Object.keys(info.similar_groups).length > 0) {
            html += '<div class="field"><span class="field-label">類似群コード:</span></div>';
            // 区分を数値として昇順ソート
            const sortedClasses = Object.keys(info.similar_groups).sort((a, b) => parseInt(a) - parseInt(b));
            for (const cls of sortedClasses) {
                const codes = info.similar_groups[cls];
                html += `<div class="similar-codes">区分${esc(cls)}: ${codes.map(c => esc(c)).join(', ')}</div>`;
            }
        }
        
        html += '</div>';
    });
    
    resultsDiv.innerHTML = html;
}

// 並び替え関数
function sortResults() {
    if (!originalSearchResults || !originalSearchResults.results) return;
    
    const sortBy = document.getElementById('sortSelector').value;
    const results = [...originalSearchResults.results]; // オリジナルからコピーを作成
    
    // ソート処理
    results.sort((a, b) => {
        const infoA = a.basic_info || a;
        const infoB = b.basic_info || b;
        
        let valA, valB;
        
        switch(sortBy) {
            case 'app_date_desc':
                valA = infoA.app_date || '';
                valB = infoB.app_date || '';
                return valB.localeCompare(valA);
            case 'app_date_asc':
                valA = infoA.app_date || '';
                valB = infoB.app_date || '';
                return valA.localeCompare(valB);
            case 'reg_date_desc':
                valA = infoA.reg_date || '';
                valB = infoB.reg_date || '';
                return valB.localeCompare(valA);
            case 'reg_date_asc':
                valA = infoA.reg_date || '';
                valB = infoB.reg_date || '';
                return valA.localeCompare(valB);
            case 'trademark_asc':
                valA = infoA.trademark_name || '';
                valB = infoB.trademark_name || '';
                return valA.localeCompare(valB);
            case 'trademark_desc':
                valA = infoA.trademark_name || '';
                valB = infoB.trademark_name || '';
                return valB.localeCompare(valA);
            default:
                return 0;
        }
    });
    
    // ソート済みの結果で再表示（originalSearchResultsは変更しない）
    currentSearchResults = {...originalSearchResults, results: results, currentSort: sortBy};
    // displayResultsを呼ばずに直接DOM更新（無限ループを防ぐ）
    updateResultsDOM(currentSearchResults);
}

// DOMのみを更新する関数（グローバル変数を変更しない）
function updateResultsDOM(data) {
    const resultsDiv = document.getElementById('results');
    
    if (!data.results || data.results.length === 0) {
        resultsDiv.innerHTML = '<div>検索結果がありません。</div>';
        return;
    }
    
    // displayResultsと同じ処理だが、currentSearchResultsやoriginalSearchResultsを変更しない
    displayResults(data);
}

// J-PlatPatを直接リンクで開く
function openJPlatPat(appNum, intlRegNum, intlRegDate) {
    console.log('openJPlatPat called with:', {appNum, intlRegNum, intlRegDate}); // デバッグ用
    
    // 出願番号から直接URLを生成
    const numStr = appNum.toString();
    
    // マドプロ案件の判定（5-6桁目が35,36,37）
    let directUrl = '';
    if (numStr.length >= 6) {
        const position5_6 = numStr.substring(4, 6);
        const isMadrid = ['35', '36', '37'].includes(position5_6);
        
        if (isMadrid && intlRegNum && intlRegDate) {
            // マドプロの場合、国際登録番号と国際登録日でURLを生成
            // 国際登録番号から先頭の0を削除
            const cleanIntlRegNum = intlRegNum.toString().replace(/^0+/, '');
            // 国際登録日は8桁のYYYYMMDD形式のまま使用
            const dateStr = intlRegDate.toString();
            // マドプロ用URLフォーマット（日付はハイフンなし）
            directUrl = `https://www.j-platpat.inpit.go.jp/c1801/TR/JP-${cleanIntlRegNum}-${dateStr}/49/ja`;
            console.log('Madrid URL:', directUrl); // デバッグ用
        } else if (isMadrid) {
            // 国際登録番号がない場合は出願番号で検索
            const year = numStr.substring(0, 4);
            const number = numStr.substring(4);
            directUrl = `https://www.j-platpat.inpit.go.jp/c1801/TR/JP-${year}-${number}/40/ja`;
        } else {
            // 通常の国内出願の場合
            // JP-YYYY-NNNNNN形式でURLを生成
            const year = numStr.substring(0, 4);
            const number = numStr.substring(4);
            // URLクエリパラメータとして渡す
            directUrl = `https://www.j-platpat.inpit.go.jp/c1801/TR/JP-${year}-${number}/40/ja`;
        }
    } else {
        // 短い番号の場合は検索ページへ
        directUrl = 'https://www.j-platpat.inpit.go.jp/t0000';
    }
    
    // 直接URLを新しいウィンドウで開く
    const newWindow = window.open(directUrl, '_blank');
    if (!newWindow) {
        alert('ポップアップがブロックされました。ブラウザの設定を確認してください。');
    }
}