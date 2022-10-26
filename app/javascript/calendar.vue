<template>
  <h1 class="text-black">カレンダー</h1>
  <h1 class="text-black">引数：{{ sample }}</h1>
</template>

<script>
export default {
  name: "calendar",
  props: {
    sample: {
      type: String,
      default: () => {}
    }
  }
}

</script>

<style scoped>

</style>
