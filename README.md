# 🏐 排球垂直跳躍生物力學與牽張-縮短循環 (SSC) LLM Wiki

> 本專案為遵循 Andrej Karpathy 提出之 **LLM Wiki 典範** 建構的專項運動科學知識庫與教學簡報系統。

---

## 📂 專案結構

```text
.
├── AGENTS.md                          # 編譯器規範、學術標準與分類架構
├── README.md                          # 專案總覽
├── tools/
│   └── lint-wiki.ps1                  # 圖譜審計腳本 (檢測斷鏈、孤島、YAML 標籤)
├── raw/                               # 不可變原始同儕審查文獻 (Immutable Source)
├── wiki/                              # 結構化 Markdown 知識圖譜 (21 篇)
│   ├── INDEX.md                       # 知識總索引 (含 Dataview 查詢與主題導引)
│   ├── LOG.md                         # 變更歷史審計日誌
│   ├── concepts/                      # 生物力學與肌肉生理機制
│   ├── protocols/                     # 實戰增強式訓練與跳躍課表
│   ├── substances/                    # 營養補充品與抗氧化策略
│   ├── contradictions/                # 學術爭鳴 (長-SSC 剛性悖論等)
│   ├── entities/                      # 學者與機構節點
│   └── synthesis/                     # 跨主題週期化藍圖
├── volleyball_jump_slides.html        # 16:9 教學演講投影片 (含通俗比喻與專項補充知識)
├── volleyball_jump_presentation.html  # 雙模態簡報與知識庫儀表板
└── volleyball_jump_dashboard.html     # 動力鏈探索儀表板
```

---

## 🚀 快速開始

### 1. 檢視教學簡報
直接以瀏覽器開啟 `volleyball_jump_slides.html`：
- **方向鍵 `→` / `Space`**：翻頁。
- **數字鍵 `1 ~ 8`**：快速切換至指定投影片。
- **按鍵 `D`**：展開 / 折疊教授審查級學術統計數據 ($R^2$, EMG, 峰值數值)。

### 2. 執行知識圖譜完整度審計
在專案根目錄開啟 PowerShell 執行：
```powershell
powershell -ExecutionPolicy Bypass -File tools/lint-wiki.ps1
```
檢查 Frontmatter 標籤規範、Wikilink 雙向鏈結與是否有孤島頁面。
