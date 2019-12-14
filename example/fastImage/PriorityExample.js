import React from 'react'
import { PixelRatio, StyleSheet, View } from 'react-native'
import withCacheBust from './withCacheBust'
import FastImage from 'react-native-fast-image-blurhash'
import Section from './Section'
import SectionFlex from './SectionFlex'
import FeatureText from './FeatureText'

const getImageUrl = (id, width, height) =>
  `https://source.unsplash.com/${id}/${width}x${height}`
const IMAGE_SIZE = 1024
const IMAGE_SIZE_PX = PixelRatio.getPixelSizeForLayoutSize(IMAGE_SIZE)
const IMAGE_URLS = [
  'https://qimg-dev.letote.cn/uploads/photo/5874/full__59A9167.JPG_2x3.jpg',
  'https://qimg-dev.letote.cn/uploads/photo/5874/full__59A9167.JPG_2x3.jpg',
  'https://qimg-dev.letote.cn/uploads/photo/5874/full__59A9167.JPG_2x3.jpg'
]

const PriorityExample = ({ onPressReload, bust }) => (
  <View>
    <Section>
      <FeatureText text="• Prioritize images (low, normal, high)." />
    </Section>
    <SectionFlex onPress={onPressReload}>
      <FastImage
        style={styles.image}
        source={{
          uri: IMAGE_URLS[0] + bust,
          priority: FastImage.priority.low
        }}
      />
      <FastImage
        style={styles.image}
        source={{
          uri: IMAGE_URLS[1] + bust,
          priority: FastImage.priority.normal
        }}
      />
      <FastImage
        style={styles.image}
        source={{
          uri: IMAGE_URLS[2] + bust,
          priority: FastImage.priority.high
        }}
      />
    </SectionFlex>
  </View>
)

const styles = StyleSheet.create({
  image: {
    flex: 1,
    height: 100,
    backgroundColor: '#ddd',
    margin: 10
  }
})

export default withCacheBust(PriorityExample)
