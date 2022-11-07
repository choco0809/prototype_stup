<template>
  <div class="my-6 flex justify-center text-black">
    <div class="w-96 mt-6">
      <div class="flex justify-center text-black text-2xl">
        <div class="w-14 h-11 px-5 text-center" @click="previousMonth">＜</div>
        <div class="w-36 h-11 text-center">{{ calendarYear }}年{{ calendarMonth }}月</div>
        <div class="w-14 h-11 px-5 text-center" @click="nextMonth">＞</div>
      </div>
      <div class="text-black">
        <table class="w-full">
          <thead>
          <tr class="bg-slate-200">
            <th class = "border border-black w-1/7">日</th>
            <th class = "border border-black w-1/7">月</th>
            <th class = "border border-black w-1/7">火</th>
            <th class = "border border-black w-1/7">水</th>
            <th class = "border border-black w-1/7">木</th>
            <th class = "border border-black w-1/7">金</th>
            <th class = "border border-black w-1/7">土</th>
          </tr>
          </thead>
          <tbody v-for="week in calendarWeeks" :key="week.id">
          <tr>
            <td v-for="date in week.value" :key="date.weekDay" class="border border-black bg-slate-100 h-20">
              <div v-if="date.date" class="text-center"> {{ date.date }} </div>
              <div v-else></div>
              <div v-if="date.totalTIme" class="text-center"> {{ date.totalTIme }}分</div>
              <div v-else-if="date.date" class="text-center"> ー </div>
            </td>
          </tr>
          </tbody>
        </table>
      </div>
      <div class="h-11">
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "calendar",
  props: {
    userId: { type: String, required: true }
  },
  data() {
    return {
      studyTimeRecords:[],
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth()
    }
  },
  mounted() {
    this.loadState()
    fetch(`/api/calendar/${this.userId}.json`, {
      method: 'GET',
      headers: {
        'X-Requested-With': 'XMLHttpRequest',
        'X-CSRF-Token': this.token()
      },
      credentials: 'same-origin'
    })
        .then((response) => {
          return response.json()
        })
        .then((json) => {
          json.forEach((r) => {
            this.studyTimeRecords.push(r)
          })
        })
        .catch((error) => {
          console.warn(error)
        })
  },
  computed: {
    calendarWeeks() {
      // 最終的にreturnする配列
      const weeksAry = []
      // 日付と曜日を格納する配列
      let value = []
      // 第何周目かを定める値
      let id = 1
      // 曜日を定める値　（ex）0は日曜日
      let weekDay = 0
      this.calendarDates.forEach(function (date, i, ary) {
        !date ? (date = { weekDay: weekDay }) : (date.weekDay = weekDay)
        value.push(date)
        weekDay++
        // 7日事に配列をまとめてpushする
        if (value.length === 7 || i === ary.length - 1) {
          weeksAry.push({ id: id, value: value })
          id++
          value = []
          weekDay = 0
        }
      })
      return weeksAry
    },
    // 当月のみの学習時間に絞り込む
    calendarStudyTime() {
      return this.studyTimeRecords.filter((record) =>
          record.start_at.includes(
              `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}`
          )
      )
    },
    calendarDates() {
      const calendar = []
      if (this.firstWday > 0) {
        for (let blank = 0; blank < this.firstWday; blank++) {
          calendar.push(null)
        }
      }
      for (let date = 1; date <= this.lastDate; date++) {
        // 対応する日付の学習記録を配列にいれる
        const result = this.calendarStudyTime.filter((records) =>
          records.end_at?.includes(
              `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}-${this.formatDay(date)}`
            )
        )
        if (result) {
          // calendar.push({ date : date, totalTIme: this.diffTime(result.start_at, result.end_at) })
          calendar.push({ date : date, totalTIme: this.sumStudyTime(result) })
        } else {
          calendar.push({ date: date })
        }
      }
      return calendar
    },
    firstWday() {
      // 当月の初日の日付を取得する
      const firstDay = new Date(this.calendarYear, this.calendarMonth - 1, 1)
      return firstDay.getDay()
    },
    lastDate() {
      // 当月の最終日の日付を取得する
      const lastDay = new Date(this.calendarYear, this.calendarMonth, 0)
      return lastDay.getDate()
    },
  },
  methods: {
    loadState() {
      const params = new URLSearchParams(location.search)
      const yearMonth = params.get('calendar') || ''
      const match = /(\d{4})-(\d{2})/.exec(yearMonth)
      if (!match) {
        return
      }
      const year = parseInt(match[1])
      const month = parseInt(match[2])
      if (new Date(year, month).getTime() > Date.now()) {
        return
      }

      this.calendarYear = year
      this.calendarMonth = month
    },
    token() {
      const meta = document.querySelector('meta[name="csrf-token"]')
      return meta ? meta.getAttribute('content') : ''
    },
    formatDay(day) {
      return day.toString().padStart(2, '0')
    },
    formatMonth(month) {
      return month.toString().padStart(2, '0')
    },
    // 現在の年（yyyy）を取得
    getCurrentYear() {
      return new Date().getFullYear()
    },
    // 現在の月（yyyy）を取得
    getCurrentMonth() {
      return new Date().getMonth() + 1
    },
    previousMonth() {
      if (this.calendarMonth === 1){
        this.calendarMonth = 12
        this.calendarYear --
      } else {
        this.calendarMonth --
      }
      this.saveState()
    },
    nextMonth() {
      if (this.calendarMonth === 12){
        this.calendarMonth = 1
        this.calendarYear ++
      } else {
        this.calendarMonth ++
      }
      this.saveState()
    },
    saveState() {
      const year = String(this.calendarYear)
      const month = String(this.calendarMonth).padStart(2, '0')
      const params = new URLSearchParams(location.search)
      params.set('calendar', `${year}-${month}`)
      // urlにパラメーターを作成する
      history.replaceState(history.state, '', `?${params}${location.hash}`)
    },
    diffTime(start_at, end_at) {
      const date1 = new Date(start_at)
      const date2 = new Date(end_at)
      return ((date2.getTime() - date1.getTime()) / (60 * 1000))
    },
    sumStudyTime(records) {
      let totalTime = 0
      const totalTimeRecords = records.map((record) =>
        this.diffTime(record.start_at, record.end_at)
      )
      if (totalTimeRecords.length != 0) {
        totalTime = totalTimeRecords.reduce((previousValue, currentValue) => previousValue + currentValue)
      }
      return totalTime
    }
  }
}

</script>
