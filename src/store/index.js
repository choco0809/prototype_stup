import { createStore } from 'vuex'

export default createStore({
  state: {
    calendarYear: '',
    calendarMonth:'',
    labels:[],
    studyTimes: []
  },
  mutations: {
    updateCalendarYear(state, payload) {
      state.calendarYear = payload.year
    },
    updateCalendarMonth(state, payload) {
      state.calendarMonth = payload.month
    },
    updateStudyTimes(state, payload) {
      state.studyTimes = payload.studyTimes
    }
  },
  getters: {
    calendarYear(state) {
      return state.calendarYear
    },
    calendarMonth(state) {
      return state.calendarMonth
    },
    studyTimeRecords(state) {
      return state.studyTimes
    }
  }
})
