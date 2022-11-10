<template>
  <div class="w-36 h-11 text-center text-black">{{ calendarYear }}年{{ calendarMonth }}月</div>
  <Bar
      :chart-options="chartOptions"
      :chart-data="chartData"
      :height="height"
  />
</template>

<script>
import { Bar } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js'

ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale)

export default {
  name: 'BarChart',
  components: { Bar },
  data() {
    return {
      calendarYear: this.getCurrentYear(),
      calendarMonth: this.getCurrentMonth(),
      chartData: {
        labels: [] ,
        datasets: [
          {
            label: '2022年11月',
            backgroundColor: '#f87979',
            data: []
          }
        ]
      },
      height: '200',
      chartOptions: {
        responsive: true,
        maintainAspectRatio: false,
        scales:{
          x: {
            ticks: {
              autoSkip: false,
              maxRotation: 0,
              minRotation: 0
            }
          },
          y: {
            min: 0,
            ticks: {
              stepSize: 1,
              callback: function (tick) {
                return tick.toString() + 'h';
              }
            }
          }
        },
        plugins: {
          legend: {
            display: false
          }
        }
      }
    }
  },
  beforeMount() {
    // mountedで値を取得した場合、描写が遅くなる
    this.chartData.labels = this.calendarDates()
  },
  mounted() {
    // calendarMonthが変わるたびに棒グラフを再作成する
    this.$store.watch(
        (state, getters) => getters.calendarMonth,
        (newVal, oldVal) => {
          this.calendarYear = this.getCurrentYear()
          this.calendarMonth = this.getCurrentMonth()
          this.chartData.labels = this.calendarDates()
      }
    )
    this.$store.watch(
        (state, getters) => getters.studyTimeRecords,
        (newVal, oldVal) => {
          this.chartData.datasets[0].data = this.getCurrentStudyTimeRecords()
        }
    )
    this.loadState()
  },
  methods: {
    getCurrentYear() {
      return this.$store.getters.calendarYear
    },
    getCurrentMonth() {
      return this.$store.getters.calendarMonth
    },
    getCurrentStudyTimeRecords() {
      return this.$store.getters.studyTimeRecords
    },
    calendarDates() {
      const calendar = []
      for (let date = 1; date <= 31; date++) {
        // 対象月が31日間でない場合は空白で埋める
        if (date <= this.lastDate()) {
          calendar.push(date)
        } else {
          calendar.push("")
        }
      }
      return calendar
    },
    lastDate() {
      // 当月の最終日の日付を取得する
      const lastDay = new Date(this.calendarYear, this.calendarMonth, 0)
      return lastDay.getDate()
    },
    previousMonth() {
      this.calendarMonth --
      this.chartData.labels = this.calendarDates()
    },
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
    }
  }
}
</script>
<style>

</style>
