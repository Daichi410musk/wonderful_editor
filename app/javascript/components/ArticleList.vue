<template>
  <v-container class="mt-5">
    <v-row>
      <v-col cols="12">
        <h2 class="mb-5">記事一覧</h2>
      </v-col>
    </v-row>

    <v-row>
      <v-col
        v-for="article in articles"
        :key="article.id"
        cols="12"
        class="mb-4"
      >
        <v-card
          class="pa-4"
          outlined
          @click="moveToArticleShow(article.id)"
          style="cursor: pointer;"
        >
          <div class="d-flex align-center mb-2">
            <!-- user があれば表示。今 name は null でも安全に動く -->
            <span
              class="mr-3 font-weight-medium"
              v-if="article.user && article.user.name"
            >
              @{{ article.user.name }}
            </span>
            <time-ago
              :refresh="60"
              :datetime="article.updated_at"
              locale="en"
              tooltip="top"
              long
            ></time-ago>
          </div>

          <div class="text-h6 font-weight-bold mb-1">
            {{ article.title }}
          </div>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import axios from "axios";
import TimeAgo from "vue2-timeago";
import Router from "../router/router";

export default {
  components: {
    TimeAgo,
  },

  data() {
    return {
      articles: [],
    };
  },

  mounted() {
    this.fetchArticles();
  },

  methods: {
    async fetchArticles() {
      await axios
        .get("/api/v1/articles")
        .then((res) => {
          // ★一番大事：配列をそのままセット
          this.articles = res.data || [];
        })
        .catch((e) => {
          console.log(e.response && e.response.data);
        });
    },

    moveToArticleShow(id) {
      Router.push(`/articles/${id}`);
    },
  },
};
</script>

<style scoped>
</style>
