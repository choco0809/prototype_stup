<template>
  <div class="my-6 flex justify-center text-black">
    <div class="md:w-150 mt-6">
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
            <td v-for="date in week.value" :key="date.weekDay" class="border border-black bg-slate-100 h-20 w-20">
              <div v-if="date.date" class="text-center"> {{ date.date }} </div>
              <div v-else></div>
              <div v-if="date.totalTIme" class="text-center">
                <label for="my-modal-3" v-on:click=getToDayStudyTimeRecords(date.date) class="btn btn-link text-black">{{ date.totalTIme }}分</label>
                <input type="checkbox" id="my-modal-3" class="modal-toggle" />
                <div class="modal">
                  <div class="modal-box relative w-11/12 max-w-5xl ">
                    <label for="my-modal-3" class="btn btn-sm btn-circle absolute right-2 top-2">✕</label>
                    <h3 class="text-lg font-bold">{{ calendarYear }}年{{ calendarMonth }}月{{ today }}日の学習記録</h3>
                    <table class="w-full">
                      <thead>
                        <tr class="bg-slate-200">
                          <th class="border border-black">開始時刻</th>
                          <th class="border border-black">終了時刻</th>
                        </tr>
                      </thead>
                      <tbody>
                        <tr v-for="date in todayStudyTime" :key="date.id">
                          <td>{{ date.start_at.slice(0,19) }}</td>
                          <td>{{ date.end_at.slice(0,19) }}</td>
                        </tr>
                      </tbody>
                    </table>
                  </div>
                </div>
              </div>
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
      today: '',
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
      const weeksAry = []
      let value = []
      let id = 1
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
    calendarStudyTime() {
      return this.studyTimeRecords.filter((record) =>
          record.start_at.includes(
              `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}`
          )
      )
    },
    todayStudyTime() {
      console.log("#todayStudyTime")
      let arry = []
      arry = this.studyTimeRecords.filter((record) =>
          record.start_at.includes(
              `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}-${this.formatDay(this.today)}`
          )
      )
      console.log(arry)
      return arry
    },
    calendarDates() {
      const calendar = []
      const monthlyStudyTimeRecords = []
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
          monthlyStudyTimeRecords.push((this.sumStudyTime(result) / 60))
        } else {
          calendar.push({ date: date })
        }
      }
      this.$store.commit('updateStudyTimes', { studyTimes: monthlyStudyTimeRecords })
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

      this.$store.commit('updateCalendarYear', { year: year  })
      this.$store.commit('updateCalendarMonth', { month: month })
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
    getCurrentYear() {
      this.$store.commit('updateCalendarYear', { year: new Date().getFullYear()  })
      return this.$store.getters.calendarYear
    },
    getCurrentMonth() {
      this.$store.commit('updateCalendarMonth', { month: new Date().getMonth() + 1 })
      return this.$store.getters.calendarMonth
    },
    previousMonth() {
      if (this.calendarMonth === 1){
        this.$store.commit('updateCalendarMonth', { month: 12 })
        this.$store.commit('updateCalendarYear', { year: this.calendarYear - 1  })
        this.calendarMonth = this.$store.getters.calendarMonth
        this.calendarYear = this.$store.getters.calendarYear
      } else {
        this.$store.commit('updateCalendarMonth', { month: this.calendarMonth - 1 })
        this.calendarMonth = this.$store.getters.calendarMonth
      }
      this.saveState()
    },
    nextMonth() {
      if (this.calendarMonth === 12){
        this.$store.commit('updateCalendarMonth', { month: 1 })
        this.$store.commit('updateCalendarYear', { year: this.calendarYear + 1  })
        this.calendarMonth = this.$store.getters.calendarMonth
        this.calendarYear = this.$store.getters.calendarYear
      } else {
        this.$store.commit('updateCalendarMonth', { month: this.calendarMonth + 1  })
        this.calendarMonth = this.$store.getters.calendarMonth
      }
      this.saveState()
    },
    saveState() {
      const year = String(this.calendarYear)
      const month = String(this.calendarMonth).padStart(2, '0')
      const params = new URLSearchParams(location.search)
      params.set('calendar', `${year}-${month}`)
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
    },
    getToDayStudyTimeRecords(date) {
      this.today = date
      // const result = this.studyTimeRecords.filter((records) =>
      //     records.end_at?.includes(
      //         `${this.calendarYear}-${this.formatMonth(this.calendarMonth)}-${this.formatDay(date)}`
      //     )
      // )
    }
  }
}

</script>
