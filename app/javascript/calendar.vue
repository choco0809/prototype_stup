<template>
  <div class="text-black">
    <div>{{ calendarYear }}年{{ calendarMonth }}月</div>
    <table>
      <thead>
        <tr class="bg-slate-200">
          <th class = "border border-black">日</th>
          <th class = "border border-black">月</th>
          <th class = "border border-black">火</th>
          <th class = "border border-black">水</th>
          <th class = "border border-black">木</th>
          <th class = "border border-black">金</th>
          <th class = "border border-black">土</th>
        </tr>
      </thead>
      <tbody v-for="week in calendarWeeks" :key="week.id">
        <tr>
          <td v-for="date in week.value" :key="date.weekDay" class="border border-black w-max bg-slate-100">
            <div class="text-center"> {{ date.date }} </div>
            <div v-if="date.date"> hh:mm </div>
          </td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script>
export default {
  name: "calendar",
  data() {
    return {
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth()
    }
  },
  mounted() {
    this.loadState()
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
    calendarDates() {
      const calendar = []
      if (this.firstWday > 0) {
        for (let blank = 0; blank < this.firstWday; blank++) {
          calendar.push(null)
        }
      }
      for (let date = 1; date <= this.lastDate; date++) {
        calendar.push({ date: date })
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
    },
    // 現在の年（yyyy）を取得
    getCurrentYear() {
      return new Date().getFullYear()
    },
    // 現在の月（yyyy）を取得
    getCurrentMonth() {
      return new Date().getMonth() + 1
    }
  }
}

</script>
